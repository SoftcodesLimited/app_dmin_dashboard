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

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String?> firestorePath = ValueNotifier<String?>(null);
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              title: 'App Data',
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
                      Expanded(flex: 4, child: Container()),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) ...[
                  const SizedBox(width: defaultPadding),
                  const Divider(),
                ],

                // On Mobile means if the screen is less than 850 we don't want to show it

                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SelectedNodeUiWidget(
                                  selectedNode: _selectedNodeNotifier.value,
                                  path: firestorePath.value,
                                ),
                                SizedBox(height: defaultPadding),
                              ]),
                        ),
                        Expanded(
                          flex: 4,
                          child: switchScreen(
                              _selectedNodeNotifier.value, firestorePath.value),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget switchScreen(node, path) {
    return node == null
        ? Container()
        : SelectedNodeUiWidget(
            path: path,
            selectedNode: node,
          );
  }
}
