import 'package:flutter/material.dart';
import 'package:myapp/utils/touch_responsive_container.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final void Function()? onPressed;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  const CustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.decoration,
    this.color,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return TouchResponsiveContainer(
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      decoration: decoration,
      color: color,
      height: height,
      width: width,
      child: child,
    );
  }
}

class MyCustomButtom extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? textColor;
  final double? conerRadius;
  final void Function()? onPressed;
  const MyCustomButtom(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.hoverColor,
      this.conerRadius,
      this.onPressed,
      this.textColor});

  @override
  Widget build(
    BuildContext context,
  ) {
    return ElevatedButton(
        style: ButtonStyle(
          foregroundColor:
              WidgetStateProperty.all<Color?>(textColor ?? Colors.white),
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor ??
              const Color.fromARGB(65, 255, 255, 255)), // Background color
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return hoverColor ??
                    const Color.fromARGB(103, 255, 255, 255); // Hover color
              }
              return null; // Default to null to keep the button's normal color
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  conerRadius ?? 0), // Adjust the corner radius
            ),
          ),
        ),
        onPressed: onPressed,
        child: child);
  }
}
