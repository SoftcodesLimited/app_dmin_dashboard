import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/custom_button.dart';
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
    final firestoreElement = data as FirestoreElement;

    if (data is! FirestoreElement) {
      return Container();
    }

    switch (firestoreElement.type) {
      case ElementType.field:
        return buidUiForElementField(
            context, path, treeNotifier, firestoreElement);
      default:
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

  Widget buidUiForElementField(
      BuildContext context,
      String? path,
      ValueNotifier<List<TreeNode<T>>> treeNotifier,
      FirestoreElement firestoreElement) {
    final ValueNotifier<bool> isUpdating = ValueNotifier<bool>(false);

    final ValueNotifier<bool> editing = ValueNotifier<bool>(false);
    final TextEditingController controller =
        TextEditingController(text: firestoreElement.data.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(firestoreElement.name, overflow: TextOverflow.ellipsis),
        ValueListenableBuilder<bool>(
            valueListenable: editing,
            builder: (context, edit, child) {
              return !edit
                  ? Row(
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
                                        strokeWidth: 1.0),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      editing.value = true;
                                    },
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 12),
                                  );
                          },
                        ),
                      ],
                    )
                  : Center(
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
                          mainAxisSize: MainAxisSize
                              .min, // Ensure the column sizes to its content
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(25, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10)),
                              child: CupertinoTextField(
                                decoration: const BoxDecoration(),
                                controller: controller,
                                style: const TextStyle(color: Colors.white),
                                onSubmitted: (value) {
                                  editing.value = false;
                                  update(controller.text, path!, treeNotifier,
                                      isUpdating);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomButton(
                                  height: 30,
                                  width: 60,
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: () {
                                    editing.value = false;
                                    update(controller.text, path!, treeNotifier,
                                        isUpdating);
                                  },
                                  child: const Center(child: Text('OK')),
                                ),
                                const SizedBox(width: 8),
                                CustomButton(
                                  height: 30,
                                  width: 60,
                                  borderRadius: BorderRadius.circular(10),
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
                    );
            }),
      ],
    );
  }
}
