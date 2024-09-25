import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

extension UiBuild<T> on TreeNode<T> {
  void update(value, path) async {
    final parts = path.split('.');
    final documentPath = parts.first;
    final fieldPath = parts.sublist(1).join('.');

    final documentReference =
        FirebaseFirestore.instance.collection('AppData').doc(documentPath);
    debugPrint('Updating: $path');
    await documentReference
        .update({
          fieldPath: value,
        })
        .then((_) {})
        .catchError((error) {
          debugPrint('Failed to update: $error');
        });
  }

  Widget buildWidget(BuildContext context, String? path) {
    if (data is! FirestoreElement) {
      return Container();
    }

    final firestoreElement = data as FirestoreElement;
    final ValueNotifier<bool> editing = ValueNotifier<bool>(false);
    final TextEditingController controller =
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
                    editing.value = true;
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: editing,
          builder: (context, isEditing, child) {
            return Visibility(
              visible: isEditing,
              child: Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          CupertinoTextField(
                            decoration: const BoxDecoration(),
                            controller: controller,
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (value) {
                              update(controller.text, path);
                              editing.value = false;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {},
                                child: const Text('OK'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  editing.value = false;
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
