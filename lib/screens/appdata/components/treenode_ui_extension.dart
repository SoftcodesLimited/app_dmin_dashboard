import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/treenode_update_extension.dart';
import 'package:myapp/services/database/database.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/customdialog.dart';
import 'package:myapp/utils/touch_responsive_container.dart';
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
    List<String> pathParts = path!.split('.');
    String parent = pathParts[0];

    switch (parent) {
      case "products":
        return buildProducts(context, firestoreElement);
      case "feeds":
        return buildFeeds(context);
    }

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

  Widget buildFeeds(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreService().getFeeds(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No feeds available."));
        } else {
          final documents = snapshot.data!.docs;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                List<String> imageList = [];

                // Extract images from Firestore document
                for (final image in document['images'].values) {
                  imageList.add(image);
                }

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromRGBO(52, 73, 94, 1))),
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
                                      document['title'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                                  color:
                                      const Color.fromARGB(29, 249, 106, 106),
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
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            MyCustomButtom(
                                              conerRadius: 8.0,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      166, 244, 67, 54),
                                              onPressed: () async {
                                                // If the user confirms deletion, delete the document
                                                await FirebaseFirestore.instance
                                                    .collection('AppData')
                                                    .doc('feeds')
                                                    .collection('feeds')
                                                    .doc(document
                                                        .id) // Use the document ID to delete
                                                    .delete();
                                                Navigator.of(context).pop(true);
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
                            document['writeUp'],
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Adjust number of columns here
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: imageList.length,
                            itemBuilder: (context, imageIndex) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: /* Image.network(
                                  imageList[imageIndex],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Image load error: $error');
                                    return const Icon(Icons.error);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ), */
                                      CachedNetworkImage(
                                    imageUrl: imageList[imageIndex],
                                    placeholder: (context, url) => SizedBox(
                                        height: 60,
                                        width: 60,
                                        child:
                                            const CircularProgressIndicator()),
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
              },
            ),
          );
        }
      },
    );
  }

  Widget buildProducts(context, FirestoreElement firestoreElement) {
    Map products = firestoreElement.data;
    int itemCount = products.length;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final productKey = products.keys.elementAt(index);
            final product = products[productKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$productKey'),
                const SizedBox(height: 5),
                Container(
                  //padding:
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          product["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                        child: Image.network(
                          product['image']!,
                          fit: BoxFit.contain,
                          // Placeholder while the image loads
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Image has loaded
                            }
                            // While loading, show a circular progress indicator
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              ),
                            );
                          },
                          // Error handler when the image fails to load
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
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
