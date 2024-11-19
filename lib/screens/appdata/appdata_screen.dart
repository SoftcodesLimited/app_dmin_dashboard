import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/screens/appdata/components/feed_add_dialog.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/selecte_node_ui.dart';
import 'package:myapp/utils/customdialog.dart';
import 'package:myapp/utils/overlay_header_option.dart';
import 'package:myapp/utils/responsive.dart';
import 'package:myapp/screens/dashboard/components/header.dart';
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
                  onOptionSelected: (String selectedOption) {
                    debugPrint(selectedOption);
                    if (selectedOption == 'Feed') {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: false,
                        dialogContent: const AddFeedDialog(),
                      );
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
                // Main Content (Tree and Selected Node UI)
                Expanded(
                  flex: 1, // Adjust to 3/4 of the screen for large screens
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:
                            2, // Adjust TreeView to take 2/3 of the main content
                        child: DocumentTreeWidget(
                          selectedNodeNotifier: _selectedNodeNotifier,
                          firestorePath: firestorePath,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  flex: 4, // Adjust Node UI to take 1/3 of the main content
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
                                treeNotifier: _treeNotifier,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                /* Divider and Secondary Content
                if (!Responsive.isMobile(context)) ...[
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    //flex: 1, // Adjust to 1/4 of the screen for large screens
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                         // flex: 1, // Placeholder for additional widgets
                          child: Container(color: Colors.transparent),
                        ),
                      ],
                    ),
                  ), 
                ],*/
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
