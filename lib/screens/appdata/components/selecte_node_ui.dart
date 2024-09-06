import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

class SelectedNodeUiWidget extends StatefulWidget {
  const SelectedNodeUiWidget({
    super.key,
    required this.selectedNode,
    required this.path,
  });

  final String? path;
  final TreeNode<FirestoreElement>? selectedNode;

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

    final element = selectedNode.data;
    final nodeName = element.name;
    final nodeType = element.type.toString().split('.').last;
    final nodeData = element.data;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Node Details',
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Name:', nodeName),
            _buildDetailRow('Type:', nodeType),
            _buildDetailRow('Path:', path),
            _buildDetailRow('Data:', nodeData.toString()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add edit or any other logic here.
                showUpdateDialog(nodeName);
              },
              child: const Text("Edit Node"),
            ),
          ],
        ),
      ),
    );
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
