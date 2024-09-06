import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/appdata_categories.dart';
import 'package:myapp/screens/appdata/components/document_tree_widget.dart';
import 'package:myapp/utils/responsive.dart';
import 'package:myapp/screens/dashboard/components/header.dart';

import '../../utils/constants.dart';

class AppDataScreen extends StatelessWidget {
  const AppDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Categories(),
                        SizedBox(height: defaultPadding),
                      ]),
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
                        const Expanded(flex: 3, child: DocumentTreeWidget()),
                        Expanded(flex: 4, child: Container()),
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
}
