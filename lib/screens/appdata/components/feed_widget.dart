import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/customdialog.dart';
import 'package:myapp/utils/debuglogs.dart';
import 'package:myapp/utils/touch_responsive_container.dart';

class FeedWidget extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> document;
  final List<String> imageList;
  const FeedWidget(
      {super.key, required this.document, required this.imageList});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  bool _isDeleting = false;

  Future<void> deleteImageFromStorage(List<String> images) async {
    try {
      setState(() {
        _isDeleting = true;
      });
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

  @override
  Widget build(BuildContext context) {
    return _isDeleting
        ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Deleting ...'),
                CircularProgressIndicator(),
              ],
            ),
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color.fromRGBO(52, 73, 94, 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.document['title'],
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TouchResponsiveContainer(
                          padding: const EdgeInsets.all(6),
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(29, 106, 123, 249),
                          child: const Icon(
                            CupertinoIcons.pencil_ellipsis_rectangle,
                            size: 16,
                            color: Colors.blue,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        TouchResponsiveContainer(
                            padding: const EdgeInsets.all(6),
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(29, 249, 106, 106),
                            child: const Icon(
                              CupertinoIcons.delete_simple,
                              size: 16,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              // Prompt user for confirmation before deletion
                              showAnimatedDialog(
                                  context: context,
                                  dialogContent: MyAlertDialog(
                                    actions: [
                                      MyCustomButtom(
                                        conerRadius: 8.0,
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      MyCustomButtom(
                                        conerRadius: 8.0,
                                        backgroundColor: const Color.fromARGB(
                                            166, 244, 67, 54),
                                        onPressed: () async {
                                          // If the user confirms deletion, delete the document
                                          await FirebaseFirestore.instance
                                              .collection('AppData')
                                              .doc('feeds')
                                              .collection('feeds')
                                              .doc(widget.document
                                                  .id) // Use the document ID to delete
                                              .delete();

                                          await deleteImageFromStorage(
                                              widget.imageList);
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                    title: const Text(
                                      "Confirm Delete",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: const Text(
                                        "Are you sure you want to delete this item?"),
                                  ),
                                  barrierDismissible: true);
                            }),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.document['writeUp'],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Adjust number of columns here
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: widget.imageList.length,
                      itemBuilder: (context, imageIndex) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: widget.imageList[imageIndex],
                              placeholder: (context, url) => SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: const CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ));
                      },
                    ),
                    const SizedBox(height: 8),
                    // const Divider(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
  }
}
