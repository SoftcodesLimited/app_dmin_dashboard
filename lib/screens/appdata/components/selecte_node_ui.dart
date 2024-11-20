import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/editscreeninfomodal.dart';
import 'package:myapp/screens/appdata/components/editscreenwidgets.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/screens/appdata/components/treenode_ui_extension.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/debuglogs.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

class SelectedNodeUiWidget extends StatefulWidget {
  SelectedNodeUiWidget({
    super.key,
    required this.selectedNode,
    required this.path,
    required this.treeNotifier,
  });

  final String? path;
  final TreeNode<FirestoreElement>? selectedNode;
  final ValueNotifier<List<TreeNode<FirestoreElement>>> treeNotifier;

  final ValueNotifier<QueryDocumentSnapshot<Object?>?> editScreendoc =
      ValueNotifier<QueryDocumentSnapshot<Object?>?>(null);
  final ValueNotifier<String?> editScreenCategory =
      ValueNotifier<String?>(null);
  final ValueNotifier<EditScreenInfo?> screenInfo =
      ValueNotifier<EditScreenInfo?>(null);

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
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      formatPath(widget.path ?? ''),
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(height: 15),
                    selectedNode.buildWidget(context, widget.path,
                        widget.treeNotifier, setEditDocScreen),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<EditScreenInfo?>(
                    valueListenable: widget.screenInfo,
                    builder: (context, info, child) {
                      return EDitScreenWidget(
                        screenInfo: info,
                      );
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  String formatPath(String path) {
    String fmtdPath = path.replaceAll('.', ' > ');
    return fmtdPath;
  }

  void setEditDocScreen(EditScreenInfo? screenInfo) {
    widget.editScreendoc.value = screenInfo?.doc;
    widget.editScreenCategory.value = screenInfo?.category;
    widget.screenInfo.value = screenInfo;
    debugLog(
      DebugLevel.info,
      'Document ${screenInfo?.doc.id}  under category ${screenInfo?.category} has been set as the current edit document',
    );
  }
}
