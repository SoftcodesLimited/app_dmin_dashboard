import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CrossPlatformSvg {
  static Widget asset(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
    String? semanticsLabel,
  }) {
    // Check if we're running on the web
    if (kIsWeb) {
      // Use Image.network for web
      return Image.network(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(error.toString());
          return const Icon(Icons.error, color: Colors.red);
        },
      );
    } else {
      // Use SvgPicture for mobile and other platforms
      return SvgPicture.network(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
        semanticsLabel: semanticsLabel,
       
      );
    }
  }
}
