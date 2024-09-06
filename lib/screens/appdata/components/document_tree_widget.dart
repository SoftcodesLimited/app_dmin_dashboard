import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/mixins/firebase_update_function_helpers.dart';
import 'package:myapp/utils/shimmer_container.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

enum ElementType { document, collection }

class FirestoreElement {
  FirestoreElement(this.name, this.type);

  final String name;
  final ElementType type;
}

class DocumentTreeWidget extends StatefulWidget {
  const DocumentTreeWidget({super.key});

  @override
  State<DocumentTreeWidget> createState() => _DocumentTreeWidgetState();
}

class _DocumentTreeWidgetState extends State<DocumentTreeWidget>
    with FirebaseFunctions {
  final treeViewKey = const TreeViewKey<FirestoreElement>();
  TreeNode<FirestoreElement>? _selectedNode;
  List<TreeNode<FirestoreElement>> _firestoreTree = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _buildTree();
  }

  Future<void> _buildTree() async {
    final categoriesSnapshot = await getCategories();

    final List<TreeNode<FirestoreElement>> treeNodes =
        categoriesSnapshot.docs.map((doc) {
      final data = doc.data() as Map<dynamic, dynamic>;
      final safeData = convertToMap(data); // Use the helper function here
      final fieldNodes = _buildFieldNodes(safeData);

      return TreeNode<FirestoreElement>(
        Key(doc.id),
        FirestoreElement(doc.id, ElementType.collection),
        fieldNodes,
      );
    }).toList();

    setState(() {
      _firestoreTree = treeNodes;
      loading = false;
    });
  }

  List<TreeNode<FirestoreElement>> _buildFieldNodes(Map<String, dynamic> data) {
    return data.entries.map<TreeNode<FirestoreElement>>((entry) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map) {
        final childNodes =
            _buildFieldNodes(convertToMap(value as Map<dynamic, dynamic>));
        return TreeNode<FirestoreElement>(
          Key(key),
          FirestoreElement('$key (Map)', ElementType.collection),
          childNodes,
        );
      } else if (value is List) {
        final childNodes = value.asMap().entries.map((listEntry) {
          final index = listEntry.key;
          final listItem = listEntry.value;

          return TreeNode<FirestoreElement>(
            Key('$key[$index]'),
            FirestoreElement('$key[$index]: $listItem', ElementType.document),
            [],
          );
        }).toList();

        return TreeNode<FirestoreElement>(
          Key(key),
          FirestoreElement('$key (List)', ElementType.collection),
          childNodes,
        );
      } else {
        return TreeNode<FirestoreElement>(
          Key(key),
          FirestoreElement('$key: $value', ElementType.document),
          [],
        );
      }
    }).toList();
  }

  Future<QuerySnapshot> getCategories() async {
    final db = FirebaseFirestore.instance;
    return await db.collection('AppData').get();
  }

  /// Method to generate the Firestore path of a selected node
  String _generateFirestorePath(TreeNode<FirestoreElement> node) {
    List<String> path = [];
    TreeNode<FirestoreElement>? currentNode = node;

    while (currentNode != null) {
      path.insert(0, currentNode.data.name.split(' ')[0]);
      currentNode = _findParentNode(_firestoreTree, currentNode);
    }

    return path.join('.');
  }

  /// Helper method to find the parent node of a given node
  TreeNode<FirestoreElement>? _findParentNode(
      List<TreeNode<FirestoreElement>> nodes,
      TreeNode<FirestoreElement> target) {
    for (var node in nodes) {
      if (node.children.contains(target)) {
        return node;
      }
      final parentNode = _findParentNode(node.children, target);
      if (parentNode != null) {
        return parentNode;
      }
    }
    return null;
  }

  /// Method to modify the selected node's data in Firestore
  Future<void> _modifySelectedNode(String newValue) async {
    if (_selectedNode != null) {
      final path = _generateFirestorePath(_selectedNode!);
      final db = FirebaseFirestore.instance;

      await db.collection('AppData').doc(_selectedNode!.data.name).update({
        path: newValue,
      });

      setState(() {
        _selectedNode = null; // Clear the selected node after update
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: TreeView<FirestoreElement>(
              key: treeViewKey,
              nodes: _firestoreTree,
              indentation: const SizedBox(
                width: 25,
              ),
              builder: (
                BuildContext context,
                TreeNode<FirestoreElement> node,
                bool isSelected,
                Animation<double> expansionAnimation,
                void Function(TreeNode<FirestoreElement>) select,
              ) {
                return GestureDetector(
                  onTap: () {
                    select(node);
                    setState(() {
                      _selectedNode = node;
                      final firestorePath = _generateFirestorePath(node);
                      print('Firestore Path: $firestorePath');
                      showUpdateDialog();
                    });
                  },
                  child: Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        if (node.data.type == ElementType.document) ...[
                          SvgPicture.asset(
                            'assets/icons/documentfield.svg',
                            height: 12,
                            width: 12,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                        Expanded(
                          child: Text(
                            node.data.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              expanderBuilder: (
                BuildContext context,
                bool isExpanded,
                Animation<double> animation,
              ) {
                return RotationTransition(
                  turns: animation,
                  child: const Icon(
                    Icons.arrow_right,
                  ),
                );
              },
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerContainer(
                      height: 15,
                      width: 15,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShimmerContainer(
                      height: 10,
                      width: 150,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ShimmerContainer(
                      height: 15,
                      width: 15,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShimmerContainer(
                      height: 10,
                      width: 120,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ShimmerContainer(
                      height: 15,
                      width: 15,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShimmerContainer(
                      height: 10,
                      width: 120,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  void showUpdateDialog() {
    TextEditingController updateController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          updateController.text = _selectedNode!.data.name;
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(16),
            title: Text('Update ${_selectedNode!.data.name}'),
            children: [
              TextField(
                controller: updateController,
              )
            ],
          );
        });
  }
}
