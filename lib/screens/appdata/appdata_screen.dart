import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/selecte_node_ui.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/customdialog.dart';
import 'package:myapp/utils/overlay_header_option.dart';
import 'package:myapp/utils/responsive.dart';
import 'package:myapp/screens/dashboard/components/header.dart';
import 'package:myapp/utils/touch_responsive_container.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';
import '../../utils/constants.dart';

class AppDataScreen extends StatelessWidget {
  AppDataScreen({super.key});

  final ValueNotifier<TreeNode<FirestoreElement>?> _selectedNodeNotifier =
      ValueNotifier<TreeNode<FirestoreElement>?>(null);
  final ValueNotifier<String?> firestorePath = ValueNotifier<String?>(null);
  final ValueNotifier<List<TreeNode<FirestoreElement>>> _treeNotifier =
      ValueNotifier<List<TreeNode<FirestoreElement>>>([]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'App Data',
              options: [
                OverlayHeaderOption(
                  icon: 'assets/icons/add-circle.svg',
                  title: 'Add',
                  onOptionSelected: (String selectedoption) {
                    debugPrint(selectedoption);
                    switch (selectedoption) {
                      case 'Feed':
                        showAnimatedDialog(
                            context: context,
                            barrierDismissible: false,
                            dialogContent: CustomActionDialog(
                              actions: [
                                Spacer(),
                                Spacer(),
                                MyCustomButtom(
                                  conerRadius: 8.0,
                                  backgroundColor: Colors.blue,
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text("Add"),
                                ),
                              ],
                              title: const Text(
                                "Add Feed",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                children: [
                                  Container(
                                   /*  padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            149, 42, 45, 62),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                52, 73, 94, 1))), */
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        const Text('Write Up'),
                                        const SizedBox(height: 10),
                                        CupertinoTextField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          maxLines: 5,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color.fromARGB(
                                                  149, 42, 45, 62),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      52, 73, 94, 1))),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('Upload photos'),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: TouchResponsiveContainer(
                                            height: 100,
                                            width: 600,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: const Color.fromARGB(
                                                    149, 42, 45, 62),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        81, 52, 73, 94))),
                                            child: const Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              color:
                                                  Color.fromRGBO(52, 73, 94, 1),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                    }
                  },
                  options: const <String>[
                    'Product',
                    'Skilling Pkg',
                    'Slider Image',
                    'Feed',
                    'Best Deal',
                  ],
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: DocumentTreeWidget(
                          selectedNodeNotifier: _selectedNodeNotifier,
                          firestorePath: firestorePath,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<TreeNode<FirestoreElement>?>(
                              valueListenable: _selectedNodeNotifier,
                              builder: (context, selectedNode, child) {
                                return ValueListenableBuilder<String?>(
                                  valueListenable: firestorePath,
                                  builder: (context, path, child) {
                                    return SelectedNodeUiWidget(
                                      selectedNode: selectedNode,
                                      path: path,
                                      treeNotifier:
                                          _treeNotifier, // Pass treeNotifier
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) ...[
                  const SizedBox(width: defaultPadding),
                  const Divider(),
                ],
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: Container()),
                        Expanded(flex: 4, child: Container()),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget switchScreen(TreeNode<FirestoreElement>? node, String? path) {
    if (node == null || path == null) {
      return Container(); // Show empty container when nothing is selected
    } else {
      return SelectedNodeUiWidget(
        path: path,
        selectedNode: node,
        treeNotifier: _treeNotifier, // Ensure treeNotifier is passed
      );
    }
  }
}
