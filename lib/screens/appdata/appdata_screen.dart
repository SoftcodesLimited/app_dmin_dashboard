import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/screens/appdata/components/selecte_node_ui.dart';
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
            const Header(title: 'App Data'),
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
                        flex: 4,
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
                                      treeNotifier: _treeNotifier, // Pass treeNotifier
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
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: ValueListenableBuilder<TreeNode<FirestoreElement>?>(
                            valueListenable: _selectedNodeNotifier,
                            builder: (context, selectedNode, child) {
                              return ValueListenableBuilder<String?>(
                                valueListenable: firestorePath,
                                builder: (context, path, child) {
                                  return SelectedNodeUiWidget(
                                    selectedNode: selectedNode,
                                    path: path,
                                    treeNotifier: _treeNotifier, // Pass treeNotifier
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(), // Placeholder for other widgets
                        ),
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
