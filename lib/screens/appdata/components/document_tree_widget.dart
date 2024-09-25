import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/mixins/firebase_update_function_helpers.dart';
import 'package:myapp/screens/appdata/components/loading_tree.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

enum ElementType { document, collection, field, parentfield }

class FirestoreElement {
  FirestoreElement(this.name, this.type);

  final String name;
  final ElementType type;
  late dynamic data;
}

class DocumentTreeWidget extends StatefulWidget {
  const DocumentTreeWidget({
    super.key,
    required this.selectedNodeNotifier,
    required this.firestorePath,
  });

  final ValueNotifier<TreeNode<FirestoreElement>?> selectedNodeNotifier;
  final ValueNotifier<String?> firestorePath;

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

  /// Builds the Firestore tree structure
  Future<void> _buildTree() async {
    final categoriesSnapshot = await getCategories();
    final List<TreeNode<FirestoreElement>> treeNodes =
        categoriesSnapshot.docs.map((doc) {
      final data = doc.data() as Map<dynamic, dynamic>;
      final safeData = convertToMap(data); // Use the helper function here
      final fieldNodes = _buildFieldNodes(safeData);

      var element = FirestoreElement(doc.id, ElementType.document);
      element.data = safeData;

      return TreeNode<FirestoreElement>(
        Key(doc.id),
        element,
        fieldNodes,
      );
    }).toList();

    setState(() {
      _firestoreTree = treeNodes;
      loading = false;
    });
  }

  /// Recursive method to build field nodes based on data structure
  List<TreeNode<FirestoreElement>> _buildFieldNodes(Map<String, dynamic> data) {
    return data.entries.map<TreeNode<FirestoreElement>>((entry) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map) {
        // Handle nested Map fields
        final childNodes = _buildFieldNodes(convertToMap(value));
        var element = FirestoreElement(key, ElementType.parentfield);
        element.data = value;
        return TreeNode<FirestoreElement>(
          Key(key),
          element,
          childNodes,
        );
      } else if (value is List) {
        // Handle List fields
        final childNodes = value.asMap().entries.map((listEntry) {
          final index = listEntry.key;
          final listItem = listEntry.value;
          var element = FirestoreElement('$key[$index]', ElementType.field);
          element.data = listItem;
          return TreeNode<FirestoreElement>(
            Key('$key[$index]'),
            element,
            [],
          );
        }).toList();

        var element = FirestoreElement('$key (List)', ElementType.parentfield);
        element.data = value;
        return TreeNode<FirestoreElement>(
          Key(key),
          element,
          childNodes,
        );
      } else {
        // Handle primitive fields
        var element = FirestoreElement(key, ElementType.field);
        element.data = value;
        return TreeNode<FirestoreElement>(
          Key(key),
          element,
          [],
        );
      }
    }).toList();
  }

  /// Fetches the categories collection from Firestore
  Future<QuerySnapshot> getCategories() async {
    final db = FirebaseFirestore.instance;
    return await db.collection('AppData').get();
  }

  /// Generates the Firestore path of a selected node
  String _generateFirestorePath(TreeNode<FirestoreElement> node) {
    List<String> path = [];
    TreeNode<FirestoreElement>? currentNode = node;

    while (currentNode != null) {
      path.insert(0, currentNode.data.name.split(' ')[0]);
      currentNode = _findParentNode(_firestoreTree, currentNode);
    }

    return path.join('.');
  }

  /// Finds the parent node of a given node
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

  /// Modifies the selected node's data in Firestore
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

  /// Shows a dialog to update the selected node's data
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

  @override
  Widget build(BuildContext context) {
    return !loading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: TreeView<FirestoreElement>(
              key: treeViewKey,
              nodes: _firestoreTree,
              indentation: const SizedBox(width: 25),
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

                    // Notify the ValueNotifiers with new values
                    widget.selectedNodeNotifier.value = node;

                    setState(() {
                      _selectedNode = node;
                      final firestorePath = _generateFirestorePath(node);

                      // Notify the path value change
                      widget.firestorePath.value = firestorePath;

                     /*  if (node.data.data != null) {
                        print('${node.data.name}: ${node.data.data}');
                      } */
                      debugPrint('Firestore Path: $firestorePath');
                    });
                  },
                  child: _buildTreeNodeItem(node),
                );
              },
              expanderBuilder: (
                BuildContext context,
                bool isExpanded,
                Animation<double> animation,
              ) {
                return RotationTransition(
                  turns: animation,
                  child: const Icon(Icons.arrow_right),
                );
              },
            ),
          )
        : const TreeLoadingWidget();
  }

  /// Builds the widget for a single tree node
  Widget _buildTreeNodeItem(TreeNode<FirestoreElement> node) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _buildIconForNode(node),
          Expanded(
            child: Text(
              node.data.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          _buildPopupMenu(node),
        ],
      ),
    );
  }

  /// Builds the appropriate icon for each node type
  Widget _buildIconForNode(TreeNode<FirestoreElement> node) {
    String iconPath;
    switch (node.data.type) {
      case ElementType.document:
        iconPath = 'assets/icons/documentfield.svg';
        break;
      case ElementType.parentfield:
        iconPath = 'assets/icons/mapIcon.svg';
        break;
      case ElementType.field:
        iconPath = 'assets/icons/fieldIcon.svg';
        break;
      default:
        iconPath = 'assets/icons/unknown.svg';
    }
    return SvgPicture.asset(
      iconPath,
      height: 12,
      width: 12,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }

  /// Builds the popup menu for each node
  Widget _buildPopupMenu(TreeNode<FirestoreElement> node) {
    return PopupMenuButton<String>(
      color: secondaryColor,
      shadowColor: const Color.fromARGB(91, 0, 0, 0),
      onSelected: (String result) {
        print('Selected option: $result');
        // Add your action logic here
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Edit',
          child: const Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Edit', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        // Add more options here if needed
      ],
      icon: const Icon(Icons.more_horiz, size: 15),
    );
  }
}
