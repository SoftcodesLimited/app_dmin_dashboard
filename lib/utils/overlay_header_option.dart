import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/simple_ptions_overlay_widget.dart';

class OverlayHeaderOption extends StatefulWidget {
  final String title;
  final String icon;

  final List<String> options;
  final void Function(String)? onOptionSelected;

  const OverlayHeaderOption({
    super.key,
    required this.icon,
    required this.title,
    required this.options,
    this.onOptionSelected,
  });

  @override
  OverlayHeaderOptionState createState() => OverlayHeaderOptionState();
}

class OverlayHeaderOptionState extends State<OverlayHeaderOption> {
  bool _isHovered = false;
  bool _isOverlayVisible = false;
  OverlayEntry? _overlayEntry;
  bool _useHover = true;

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
      _isHovered = true;
      _useHover = false;
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    setState(() {
      _isOverlayVisible = false;
      _isHovered = false;
      _useHover = true;
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
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: offset.dx - (size.width * 1.5 / 3),
            top: offset.dy + size.height + 5,
            width: size.width * 2,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.white10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(91, 0, 0, 0),
                          offset: Offset(5, 5),
                          blurRadius: 5)
                    ]),
                child: SimpleOverlayWidget(
                  options: widget.options,
                  onOptionSelected: widget.onOptionSelected,
                  toggleVisibility: () {
                    _toggleOverlay(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => setState(() {
              _isHovered = true;
            }),
        onExit: (_) => setState(() {
              _isHovered = _useHover ? false : true;
            }),
        child: GestureDetector(
          onTap: () => _toggleOverlay(context),
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
        ));
  }
}
