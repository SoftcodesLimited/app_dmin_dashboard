import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/treenode_update_extension.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

extension UiBuild<T> on TreeNode<T> {
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
      case ElementType.parentfield:
        return buildUiForParentFields(
            context, path, treeNotifier, firestoreElement);
      case ElementType.document:
        return buildDocumentUi(context, path, treeNotifier, firestoreElement);
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

  Widget buildDocumentUi(
      BuildContext context,
      String? path,
      ValueNotifier<List<TreeNode<T>>> treeNotifier,
      FirestoreElement firestoreElement) {
        return Container();
      }

  Widget buildUiForParentFields(
      BuildContext context,
      String? path,
      ValueNotifier<List<TreeNode<T>>> treeNotifier,
      FirestoreElement firestoreElement) {
    List<String> pathParts = path!.split('.');
    String parent = pathParts[0];

    switch (parent) {
      case "products":
        return buildIndividualproduct(firestoreElement);
    }

    return Container();
  }

  Widget buildIndividualproduct(FirestoreElement firestoreElement) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            firestoreElement.data["name"],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          Image(
              image: NetworkImage(firestoreElement.data["image"]), height: 300),
          const SizedBox(height: 15),
          const Text("desc", style: TextStyle(color: Colors.grey)),
          const SizedBox(
            height: 10,
          ),
          Text(firestoreElement.data["desc"]),
          const SizedBox(height: 15),
          const Text("Video", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(firestoreElement.data["Videourl"] ?? ''),
          const SizedBox(height: 15),
          const Text("Web Url", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(firestoreElement.data["weburl"])
        ],
      ),
    );
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
