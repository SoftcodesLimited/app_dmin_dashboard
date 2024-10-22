import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/touch_responsive_container.dart';

class AnimatedDialog extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedDialog({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  AnimatedDialogState createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        );
      },
    );
  }
}

void showAnimatedDialog({required BuildContext context, required Widget dialogContent,required bool barrierDismissible}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible, // Can dismiss dialog by tapping outside
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Transparent background
        child: AnimatedDialog(
          child: dialogContent,
        ),
      );
    },
  );
}

class MyAlertDialog extends StatelessWidget {
  final List<Widget> actions;
  final Widget title;
  final Widget content;
  const MyAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color.fromARGB(68, 0, 0, 0),
            offset: Offset(10, 10),
            blurRadius: 10)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(149, 42, 45, 62),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 200,
                maxWidth: 400,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                title,
                const SizedBox(height: 20),
                content,
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      Expanded(child: actions[i]),
                      if (i != actions.length - 1) const SizedBox(width: 10),
                    ],
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomActionDialog extends StatefulWidget {
  final List<Widget> actions;
  final Widget title;
  final Widget content;

  const CustomActionDialog(
      {super.key,
      required this.actions,
      required this.title,
      required this.content});

  @override
  State<CustomActionDialog> createState() => _CustomActionDialogState();
}

class _CustomActionDialogState extends State<CustomActionDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color.fromARGB(68, 0, 0, 0),
            offset: Offset(10, 10),
            blurRadius: 10)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(149, 42, 45, 62),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 400,
                maxWidth: 600,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TouchResponsiveContainer(
                        padding: const EdgeInsets.all(0),
                        borderRadius: BorderRadius.circular(5),
                        //color: const Color.fromARGB(29, 249, 106, 106),
                        child: const Icon(
                          CupertinoIcons.xmark_circle_fill,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                widget.title,
                const SizedBox(height: 10),
                widget.content,
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (int i = 0; i < widget.actions.length; i++) ...[
                      Expanded(child: widget.actions[i]),
                      if (i != widget.actions.length - 1)
                        const SizedBox(width: 10),
                    ],
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
