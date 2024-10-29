import 'package:ansi_styles/ansi_styles.dart';
import 'package:flutter/cupertino.dart';

enum DebugLevel {
  debug(level: 'DEBUG'),
  warn(level: 'WARN '),
  info(level: 'INFO '),
  error(level: 'ERROR');

  final String level;
  const DebugLevel({required this.level});
}

void debugLog(DebugLevel level, String message) {
  final timestamp = DateTime.now().toString();

  // Set colors for different log levels
  final color = {
        'DEBUG': AnsiStyles.blue,
        'INFO ': AnsiStyles.green,
        'WARN ': AnsiStyles.yellow,
        'ERROR': AnsiStyles.red,
      }[level.level] ??
      AnsiStyles.white;

  // Construct the formatted log message
  final formattedMessage =
      '${AnsiStyles.gray('[$timestamp]')} ${AnsiStyles.green('[DEBUG]')} ${color('[${level.level}]')}: $message';

  // Print the colored log message
  debugPrint(formattedMessage);
}
