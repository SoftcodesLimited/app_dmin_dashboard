import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

extension UiBuild<T> on TreeNode<T> {
  Widget buildWidget(BuildContext context, String? path) {
    // Check if the data is of type FirestoreElement
    if (data is! FirestoreElement) {
      return Container();
    }

    final firestoreElement = data as FirestoreElement;
    final ValueNotifier<bool> _isEditing = ValueNotifier<bool>(false);
    final TextEditingController _controller =
        TextEditingController(text: firestoreElement.data.toString());

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firestoreElement.name,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    firestoreElement.data.toString(),
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _isEditing.value = true;
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isEditing,
          builder: (context, isEditing, child) {
            return Visibility(
              visible: isEditing,
              child: Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoTextField(
                            decoration: BoxDecoration(
                                /* color: secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                              ), */
                                ),
                            controller: _controller,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // Update Firestore with the new value
                                  await FirebaseFirestore.instance
                                      .collection(
                                          'AppData') // Replace with your collection
                                      .doc(
                                          path) // Use the path for document reference
                                      .update({
                                    firestoreElement.name: _controller
                                        .text, // Update with new value
                                  }).then((_) {
                                    print('Updated successfully!');
                                    _isEditing.value = false;
                                  }).catchError((error) {
                                    print('Failed to update: $error');
                                  });
                                },
                                child: const Text('OK'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  _isEditing.value = false;
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
