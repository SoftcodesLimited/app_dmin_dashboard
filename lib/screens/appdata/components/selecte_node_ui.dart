import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/treenode_ui_extension.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

class SelectedNodeUiWidget extends StatefulWidget {
  const SelectedNodeUiWidget({
    super.key,
    required this.selectedNode,
    required this.path,
    required this.treeNotifier, // Add treeNotifier as a required field
  });

  final String? path;
  final TreeNode<FirestoreElement>? selectedNode;
  final ValueNotifier<List<TreeNode<FirestoreElement>>>
      treeNotifier; // Declare treeNotifier

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatPath(widget.path ?? ''),
                style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 15),
            selectedNode.buildWidget(
              context,
              widget.path,
              widget.treeNotifier, // Pass treeNotifier here
            ),
          ],
        );
      },
    );
  }

  String formatPath(String path) {
    String fmtdPath = path.replaceAll('.', ' > ');
    return fmtdPath;
  }

  /// Helper method to build a row for displaying details
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Dummy function to handle edit (to be replaced with actual logic)
  void showUpdateDialog(String nodeName) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController updateController =
            TextEditingController(text: nodeName);
        return AlertDialog(
          title: Text('Edit $nodeName'),
          content: TextField(
            controller: updateController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement your update logic here
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
