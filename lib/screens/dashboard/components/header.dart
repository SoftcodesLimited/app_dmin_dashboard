import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/controllers/menu_app_controller.dart';
import 'package:myapp/utils/responsive.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';

class Header extends StatelessWidget {
  final String title;
  final List<Widget>? options;
  const Header({
    super.key,
    required this.title,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: secondaryColor, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: context.read<MenuAppController>().controlMenu,
            ),
          if (!Responsive.isMobile(context))
            const SizedBox(
              width: 20,
            ),
          if (!Responsive.isMobile(context))
            Text(
              title,
              style: GoogleFonts.actor(
                textStyle: const TextStyle(
                  fontSize: 24, // Set font size
                  fontWeight: FontWeight.bold, // Set font weight
                  color: Colors.white, // Set text color
                  letterSpacing: 1.2, // Set letter spacing
                ),
              ),
            ),
          const SizedBox(
            width: 100,
          ),
          Expanded(child: SearchField()),

          if (!Responsive.isMobile(context))
            Spacer(
              flex: Responsive.isDesktop(context) ? 1 : 1,
            ),
          //Expanded(child: SearchField()),
          if (!Responsive.isMobile(context))
            if (options != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: options!,
              ),
          ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _toggleOverlay(context),
      child: Container(
        margin: EdgeInsets.only(left: 16.0),
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          // border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/images/aisha.jpg",
                fit: BoxFit.cover,
                height: 28,
                width: 28,
              ),
            ),
            if (!Responsive.isMobile(context))
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Katherine Edison"),
              ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _toggleOverlay(BuildContext context) {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay(context);
    }
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    setState(() {
      _isOverlayVisible = false;
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideOverlay,
            child: Container(
              color: Colors
                  .transparent, // Transparent background to detect outside clicks
            ),
          ),
          Positioned(
            left: offset.dx - (size.width * 1.5 / 3),
            top: offset.dy + size.height + 5,
            width: size.width * 1.5,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.white10),
                    boxShadow: const [
                      BoxShadow(
                          color: const Color.fromARGB(91, 0, 0, 0),
                          offset: Offset(5, 5),
                          blurRadius: 5)
                    ]),
                child: _buildExpandedOptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            "assets/images/aisha.jpg",
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "John Doe",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          "johndoe@eaxample.com",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 30),
        CupertinoButton(
            child: Text(
              'SignOut',
              style: TextStyle(color: Colors.red, fontSize: 15),
            ),
            onPressed: () {})
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      prefixIcon: Container(),
      style: TextStyle(color: Colors.white),
    ); /* TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: const Color.fromARGB(73, 110, 118, 160),
        filled: true,
        
        border: const OutlineInputBorder(
          gapPadding: 1,
          borderSide: BorderSide.none, //BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.85),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            width: 70,
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(26, 0, 0, 0),
                      offset: Offset(-5, 5),
                      blurRadius: 5),
                ]),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    ); */
  }
}

class HeaderOption extends StatefulWidget {
  final String title;
  final String icon;
  final bool isActive;
  final int index;

  final void Function(int index)? getIndex;

  const HeaderOption({
    super.key,
    required this.icon,
    this.isActive = false,
    required this.index,
    this.getIndex,
    required this.title,
  });

  @override
  DesktopMenuItemState createState() => DesktopMenuItemState();
}

class DesktopMenuItemState extends State<HeaderOption> {
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
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isHovered ? Colors.white.withOpacity(0.2) : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(widget.title),
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    widget.icon,
                    width: 25,
                    height: 25,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
