import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  const ShimmerContainer(
      {super.key, this.borderRadius, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: const Color.fromARGB(54, 158, 158, 158),
        highlightColor: const Color.fromARGB(78, 87, 86, 86),
        child: Container(
          height: height,
          width: width,
          decoration:
              BoxDecoration(borderRadius: borderRadius, color: Colors.grey),
        ),
      ),
    );
  }
}
