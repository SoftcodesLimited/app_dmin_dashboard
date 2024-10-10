import 'package:flutter/material.dart';

class SimpleOverlayWidget extends StatelessWidget {
  final List<String>? options;
  final void Function()? toggleVisibility;
  final void Function(String)? onOptionSelected;

  const SimpleOverlayWidget({
    super.key,
    required this.options,
    this.onOptionSelected,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options != null
            ? options!
                .map((option) => GestureDetector(
                      child: OptionWidget(optionName: option),
                      onTap: () {
                        if (onOptionSelected != null) {
                          toggleVisibility!();
                          onOptionSelected!(option);
                        } else {
                          toggleVisibility!();
                        }
                      },
                    ))
                .toList()
            : [],
      ),
    );
  }
}

class OptionWidget extends StatefulWidget {
  final String optionName;
  const OptionWidget({super.key, required this.optionName});

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
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
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
              color:
                  _isHovered ? const Color.fromARGB(39, 255, 255, 255) : null,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Text(widget.optionName),
            ],
          )),
    );
  }
}
