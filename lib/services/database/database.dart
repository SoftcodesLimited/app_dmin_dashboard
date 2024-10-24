import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/messaging/message_model.dart';

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
    return appData.doc('feeds').collection('feeds').snapshots();
  }

  Future<List<String>> uploadFeedImages(
      {required List<XFile> selectedImages, required String title}) async {
    List<String> imageUrls = [];

    for (XFile image in selectedImages) {
      try {
        // Convert the image file to a byte array (Uint8List)
        Uint8List imageData = await image.readAsBytes();

        // Create a unique file path for the image in Firebase Storage
        String filePath =
            'feeds/${title}_${DateTime.now().millisecondsSinceEpoch}_${image.name}';

        // Upload image to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        UploadTask uploadTask = storageRef.putData(imageData);
        TaskSnapshot snapshot = await uploadTask;

        // Get the URL of the uploaded image
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return imageUrls;
  }
}
