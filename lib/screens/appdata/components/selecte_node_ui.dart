import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/treenode_ui_extension.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

class SelectedNodeUiWidget extends StatefulWidget {
  const SelectedNodeUiWidget({
    super.key,
    required this.selectedNode,
    required this.path,
    required this.treeNotifier,
  });

  final String? path;
  final TreeNode<FirestoreElement>? selectedNode;
  final ValueNotifier<List<TreeNode<FirestoreElement>>> treeNotifier;

  @override
  State<SelectedNodeUiWidget> createState() => _SelectedNodeUiWidgetState();
}

class _SelectedNodeUiWidgetState extends State<SelectedNodeUiWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedNode = widget.selectedNode;
    final path = widget.path;

    if (selectedNode == null || path == null) {
      return const Center(
        child: Text("No node selected"),
      );
    }

    return ValueListenableBuilder<List<TreeNode<FirestoreElement>>>(
      valueListenable: widget.treeNotifier,
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatPath(widget.path ?? ''),
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 15),
              selectedNode.buildWidget(
                  context, widget.path, widget.treeNotifier),
            ],
          ),
        );
      },
    );
  }

  String formatPath(String path) {
    String fmtdPath = path.replaceAll('.', ' > ');
    return fmtdPath;
  }
}
