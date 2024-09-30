import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

extension UiBuild<T> on TreeNode<T> {
  void update(
    String value,
    String path,
    ValueNotifier<List<TreeNode<T>>> treeNotifier,
    ValueNotifier<bool> isUpdating,
  ) async {
    isUpdating.value = true; // Set isUpdating to true before update starts

    final parts = path.split('.');
    final documentPath = parts.first;
    final fieldPath = parts.sublist(1).join('.');

    final documentReference =
        FirebaseFirestore.instance.collection('AppData').doc(documentPath);
    debugPrint('Updating: $path');

    await documentReference.update({fieldPath: value}).then((_) {
      debugPrint('Firestore updated successfully.');

      // Update the local node data
      if (data is FirestoreElement) {
        final firestoreElement = data as FirestoreElement;
        firestoreElement.data = value;

        // Notify listeners after updating the tree structure
        treeNotifier.value = List<TreeNode<T>>.from(treeNotifier.value);
        debugPrint('UI updated with new value: $value');
        isUpdating.value =
            false; // Set isUpdating to false after update completes
      }
    }).catchError((error) {
      debugPrint('Failed to update: $error');
      isUpdating.value = false; // Set isUpdating to false if the update fails
    });
  }

  Widget buildWidget(BuildContext context, String? path,
      ValueNotifier<List<TreeNode<T>>> treeNotifier) {
    if (data is! FirestoreElement) {
      return Container();
    }

    final ValueNotifier<bool> isUpdating = ValueNotifier<bool>(false);
    final firestoreElement = data as FirestoreElement;
    final ValueNotifier<bool> editing = ValueNotifier<bool>(false);
    final TextEditingController controller =
        TextEditingController(text: firestoreElement.data.toString());

    if (firestoreElement.type == ElementType.field) {
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
                    child: Column(
                      children: [
                        Text(
                          firestoreElement.data.toString(),
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<bool>(
                    valueListenable: isUpdating,
                    builder: (context, updating, child) {
                      return updating
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                editing.value = true;
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 12,
                              ),
                            );
                    },
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
                                editing.value = false;
                                update(
                                  controller.text,
                                  path!,
                                  treeNotifier,
                                  isUpdating,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    editing.value = false;
                                    update(
                                      controller.text,
                                      path!,
                                      treeNotifier,
                                      isUpdating,
                                    );
                                  },
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
    } else {
      return GestureDetector(
        onTap: () {
          // Define what happens on tap, like navigating to its children
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firestoreElement
                  .name, // Display the name of the collection or document
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            firestoreElement.data is Map
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        (firestoreElement.data as Map).entries.map((entry) {
                      return Text('${entry.key}: ${entry.value}');
                    }).toList(),
                  )
                : Container(),
          ],
        ),
      );
    }
  }
}
