import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/screens/appdata/components/feed_add_dialog.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/debuglogs.dart';
import 'package:myapp/utils/touch_responsive_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class FeedEditWidget extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> doc;
  const FeedEditWidget({super.key, required this.doc});

  @override
  State<FeedEditWidget> createState() => _FeedEditWidgetState();
}

class _FeedEditWidgetState extends State<FeedEditWidget> {
  late List<String> imageList;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.doc['title'];
    descController.text = widget.doc['writeUp'];
    imageList = [];
    if (widget.doc['images'] != null) {
      for (final image in widget.doc['images'].values) {
        imageList.add(image);
      }
    }
  }

  Future<void> _addPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        // For Web: Convert the file into a Blob URL
        final Uint8List bytes = await image.readAsBytes();
        final html.Blob blob = html.Blob([bytes]);
        final String blobUrl = html.Url.createObjectUrlFromBlob(blob);
        setState(() {
          imageList.add(blobUrl);
        });
      } else {
        // For Mobile/Other Platforms: Use file path or upload logic
        setState(() {
          imageList.add(image.path); // Add the file path or server URL
        });
      }
    }
  }

  Future<void> saveChanges() async {
    debugLog(DebugLevel.debug, 'Updating');
    setState(() {
      isSaving = true;
    });
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final CollectionReference collection = FirebaseFirestore.instance
          .collection("AppData")
          .doc('feeds')
          .collection('feeds');

      // Get the original images from the document
      final Map<String, dynamic> originalImages = widget.doc['images'] ?? {};

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
      await collection.doc(widget.doc.id).update({
        'title': titleController.text,
        'writeUp': descController.text,
        'images': {
          for (int i = 0; i < updatedImageUrls.length; i++)
            'image_$i': updatedImageUrls[i]
        },
      });

      debugLog(DebugLevel.debug, 'Changes saved successfully!');
    } catch (e) {
      debugLog(DebugLevel.error, 'Failed to save changes: $e');
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    imageList = [];
  }

  @override
  void didUpdateWidget(covariant FeedEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.doc.id != oldWidget.doc.id) {
      // Update the UI when the doc changes
      setState(() {
        titleController.text = widget.doc['title'];
        descController.text = widget.doc['writeUp'];
        imageList = [];
        if (widget.doc['images'] != null) {
          for (final image in widget.doc['images'].values) {
            imageList.add(image);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit Feed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
            const SizedBox(height: 10),
            Text("Title", style: TextStyle(color: Colors.grey)),
            GlowingBorderTextField(
              placeholder: 'Title',
              controller: titleController,
            ),
            const SizedBox(height: 10),
            Text("Description", style: TextStyle(color: Colors.grey)),
            GlowingBorderTextField(
              maxLines: 3,
              placeholder: "Description",
              controller: descController,
            ),
            const SizedBox(height: 10),
            Text("Photos", style: TextStyle(color: Colors.grey)),
            SizedBox(
              width: 600,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TouchResponsiveContainer(
                      height: 150,
                      width: 130,
                      onPressed: _addPhoto, // Call the function to add a photo
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(149, 42, 45, 62),
                        border: Border.all(
                            color: const Color.fromARGB(81, 52, 73, 94)),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Color.fromRGBO(52, 73, 94, 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    for (int i = imageList.length - 1; i >= 0; i--) ...[
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(17, 0, 0, 0),
                                    blurRadius: 3,
                                    offset: Offset(2, 2))
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                imageList[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageList.removeAt(i); // Remove the image
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MyCustomButtom(
              conerRadius: 8.0,
              backgroundColor: Colors.blue,
              onPressed: isSaving ? null : saveChanges,
              child: isSaving
                  ? SizedBox(
                      height: 20,
                      width: 150,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
