import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/utils/constants.dart';

class SideMenu extends StatelessWidget {
  final double? width;
  const SideMenu({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: width,
      child: ListView(
        children: [
          Container(
              child: Image.asset("assets/images/logo.png"),
              height: 50,
              width: 50),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Task",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Documents",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 20,
        width: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

class DesktopSideMenu extends StatefulWidget {
  final void Function(int index)? getIndex;
  final void Function(bool isHovered)? onHover;
  const DesktopSideMenu({super.key, this.getIndex, this.onHover});

  @override
  State<DesktopSideMenu> createState() => _DesktopSideMenuState();
}

class _DesktopSideMenuState extends State<DesktopSideMenu> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
        if (widget.onHover != null) {
          widget.onHover!(_isHovered);
        }
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
        if (widget.onHover != null) {
          widget.onHover!(_isHovered);
        }
      }),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
        child: Container(
          width: _isHovered ? 50 : null,
          decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(64, 0, 0, 0),
                    offset: Offset(5, 5),
                    blurRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: _isHovered
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: _isHovered
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                    : const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/SOFTCODES.png",
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              DesktopMenuItem(
                title: "Dashboard",
                icon: "assets/icons/menu_dashboard.svg",
                isActive: true,
                index: 0,
                getIndex: widget.getIndex,
                parentHovered: _isHovered,
              ),
              DesktopMenuItem(
                title: "Chats",
                icon: "assets/icons/messages_menu.svg",
                index: 1,
                getIndex: widget.getIndex,
                parentHovered: _isHovered,
              ),
              DesktopMenuItem(
                title: "App Data",
                icon: "assets/icons/menu_phone.svg",
                index: 2,
                getIndex: widget.getIndex,
                parentHovered: _isHovered,
              ),
              DesktopMenuItem(
                title: "Notifications",
                icon: "assets/icons/menu_notification.svg",
                index: 3,
                getIndex: widget.getIndex,
                parentHovered: _isHovered,
              ),
              Spacer(),
              DesktopMenuItem(
                title: "Settings",
                icon: "assets/icons/menu_setting.svg",
                index: 4,
                getIndex: widget.getIndex,
                parentHovered: _isHovered,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopMenuItem extends StatefulWidget {
  final String title;
  final String icon;
  final bool isActive;
  final int index;
  final bool parentHovered;
  final void Function(int index)? getIndex;

  const DesktopMenuItem({
    super.key,
    required this.icon,
    this.isActive = false,
    required this.index,
    this.getIndex,
    required this.parentHovered,
    required this.title,
  });

  @override
  DesktopMenuItemState createState() => DesktopMenuItemState();
}

class DesktopMenuItemState extends State<DesktopMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),
      child: GestureDetector(
        onTap: () {
          if (widget.getIndex != null) {
            widget.getIndex!(widget.index);
          }
        },
        child: Padding(
          padding: widget.parentHovered
              ? const EdgeInsets.only(bottom: 0, top: 0, left: 8, right: 8)
              : const EdgeInsets.only(bottom: 0, top: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white.withOpacity(0.2) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.parentHovered
                ? Row(
                    children: [
                      SvgPicture.asset(
                        widget.icon,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.title)
                    ],
                  )
                : SvgPicture.asset(
                    widget.icon,
                    width: 20,
                    height: 20,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
          ),
        ),
      ),
    );
  }
}
