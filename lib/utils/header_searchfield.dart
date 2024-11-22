import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool _isOverlayVisible = false;
  OverlayEntry? _overlayEntry;
  TextEditingController searchController = TextEditingController();

  void toggleOverlay(BuildContext context) {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay(context);
    }
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _hideOverlay(); // Remove any existing overlay to prevent duplicates
    }
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove(); // Properly remove the overlay
      _overlayEntry = null; // Clear the reference
      setState(() {
        _isOverlayVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - (size.width * 1.5 / 3),
        top: offset.dy + size.height + 5,
        width: size.width * 3,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(91, 0, 0, 0),
                offset: Offset(5, 5),
                blurRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: const Color.fromARGB(193, 42, 45, 62),
                child: const SizedBox(
                  height: 300,
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: searchController,
      /*onSuffixTap: () {
        setState(() {
          searchController.text = '';
        });

        _hideOverlay();
      },*/
      onChanged: (value) {
        if (value.isEmpty) {
          _hideOverlay();
        } else {
          _showOverlay(context);
        }
      },
      style: const TextStyle(color: Colors.white),
    );
  }
}
