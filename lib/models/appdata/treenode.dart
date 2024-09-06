import 'package:cloud_firestore/cloud_firestore.dart';

class TreeNode {
  final String name;
  final List<TreeNode> children;

  TreeNode(this.name, [this.children = const []]);
}

Future<List<TreeNode>> fetchNodesFromCollection(String collectionPath) async {
  final collection = FirebaseFirestore.instance.collection(collectionPath);
  final snapshot = await collection.get();

  List<TreeNode> nodes = [];
  for (var doc in snapshot.docs) {
    nodes.add(TreeNode(doc.id));
  }

  return nodes;
}
