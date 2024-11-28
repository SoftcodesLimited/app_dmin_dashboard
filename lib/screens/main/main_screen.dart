import 'package:flutter/material.dart';
import 'package:myapp/controllers/menu_app_controller.dart';
import 'package:myapp/utils/responsive.dart';
import 'package:myapp/screens/appdata/appdata_screen.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:myapp/screens/messages/messages_screen.dart';
import 'package:myapp/screens/notifications/notifications_screen.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  final ValueNotifier<int> activeIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isHovered = ValueNotifier<bool>(false);

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              ValueListenableBuilder<bool>(
                valueListenable: isHovered,
                builder: (context, isHovered, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: isHovered ? 250 : 80,
                    child: GestureDetector(
                      onTap: () => isHovered = !isHovered,
                      child: MouseRegion(
                        onEnter: (_) => this.isHovered.value = true,
                        onExit: (_) => this.isHovered.value = false,
                        child: DesktopSideMenu(
                          getIndex: (index) {
                            if (activeIndex.value != index) {
                              switch (activeIndex.value) {
                                case 0:
                                  DashboardScreen();
                                case 1:
                                  MessagesScreen();
                                case 2:
                                  AppDataScreen();
                                case 3:
                                  NotificationsScreen();
                                default:
                                  Container();
                              }
                            }
                            activeIndex.value = index;
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            Expanded(
              flex: 20,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: activeIndex,
                  builder: (context, index, child) {
                    return switchScreen(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget switchScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return MessagesScreen();
      case 2:
        return AppDataScreen();
      case 3:
        return const NotificationsScreen();
      default:
        return Container();
    }
  }
}
