import 'dart:typed_data';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/messaging/message_model.dart';
import 'package:myapp/utils/debuglogs.dart';

class FirestoreService {
  final CollectionReference appData =
      FirebaseFirestore.instance.collection("AppData");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference chatRoom =
      FirebaseFirestore.instance.collection("ChatRooms");
  final CollectionReference applications =
      FirebaseFirestore.instance.collection("Applications");
  final CollectionReference orders =
      FirebaseFirestore.instance.collection("Orders");
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('Appointments');
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');
  final CollectionReference sliderData =
      FirebaseFirestore.instance.collection("slider");

  Future<void> uploadMessage(String chatRoomId, Message message) async {
    final chatRoomRef = chatRoom.doc(chatRoomId);
    await chatRoomRef.collection('messages').add(message.toMap());
    await chatRoomRef.set(
      {
        'updateTime': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> pushOrder(dynamic order) async {
    await orders
        .doc(order.customer.softCodesId)
        .collection('orders')
        .add(order.toMap());
  }

  Stream<QuerySnapshot> getFeeds() {
    return appData
        .doc('feeds')
        .collection('feeds')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<List<String>> uploadFeedImages(
      {required List<XFile> selectedImages, required String title}) async {
    List<String> imageUrls = [];

    for (XFile image in selectedImages) {
      try {
        // Convert the image file to a byte array (Uint8List)
        Uint8List imageData = await image.readAsBytes();

        // Create a unique file path for the image in Firebase Storage
        String filePath = 'feeds/${title}_${image.name}';

        // Upload image to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        UploadTask uploadTask = storageRef.putData(
            imageData, SettableMetadata(contentType: 'image/jpeg'));
        TaskSnapshot snapshot = await uploadTask;

        // Get the URL of the uploaded image
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        rethrow;
      }
    }

    return imageUrls;
  }

  Future<void> deleteImageFromStorage(List<String> images) async {
    try {
      for (String image in images) {
        // Extract the file path from the download URL
        final ref = FirebaseStorage.instance.refFromURL(image);

        // Delete the file
        await ref.delete();
        debugLog(DebugLevel.info, 'image $image has been deleted sucessfully');
      }
    } catch (e) {
      debugLog(DebugLevel.error,
          'Failed to delet image due to error: ${e.toString()}');
    }
  }

  Future<void> updateFeed(QueryDocumentSnapshot<Object?> doc, String title,
      String writeUp, List<String> imageList) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final CollectionReference collection =
          appData.doc('feeds').collection('feeds');

      // Get the original images from the document
      final Map<String, dynamic> originalImages = doc['images'] ?? {};

      // Identify removed images (present in original but not in `imageList`)
      final List<String> removedImageUrls = originalImages.values
          .where((url) => !imageList.contains(url))
          .cast<String>()
          .toList();

      // Identify new images (Blob URLs in `imageList` that are not in the original)
      final List<String> newImages =
          imageList.where((url) => url.startsWith('blob:')).toList();

      // Prepare the updated image URLs list
      final List<String> updatedImageUrls = [];

      // Handle uploading new images
      for (final image in newImages) {
        final Uint8List bytes = await html.HttpRequest.request(image,
                responseType: 'arraybuffer')
            .then((value) => Uint8List.fromList(value.response as List<int>))
            .catchError((error) {
          throw Exception("Failed to fetch image bytes: $error");
        });

        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = storage.ref('images/$fileName');
        await storageRef.putData(bytes);
        final String downloadUrl = await storageRef.getDownloadURL();
        updatedImageUrls.add(downloadUrl);
      }

      // Retain existing images still present in `imageList`
      for (final url in imageList) {
        if (!url.startsWith('blob:')) {
          updatedImageUrls.add(url);
        }
      }

      // Delete removed images from Firebase Storage
      for (final url in removedImageUrls) {
        try {
          final Reference storageRef = storage.refFromURL(url);
          await storageRef.delete();
        } catch (error) {
          debugLog(
              DebugLevel.error, "Failed to delete image: $url, error: $error");
        }
      }

      // Update Firestore document
      await collection.doc(doc.id).update({
        'title': title,
        'writeUp': writeUp,
        'images': {
          for (int i = 0; i < updatedImageUrls.length; i++)
            'image_$i': updatedImageUrls[i]
        },
      });

      debugLog(DebugLevel.debug, 'Changes saved successfully!');
    } catch (e) {
      rethrow;
    }
  }
}
