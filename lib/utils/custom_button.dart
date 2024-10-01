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
      child: child,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      decoration: decoration,
      color: color,
      height: height,
      width: width,
    );
  }
}
