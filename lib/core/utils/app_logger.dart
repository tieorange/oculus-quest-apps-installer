import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Application logger with structured output.
class AppLogger {
  AppLogger._();

  static const String _name = 'QuestGameManager';

  /// Log debug information (only in debug mode).
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      _log('DEBUG', message, tag: tag);
    }
  }

  /// Log general info.
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Log warnings.
  static void warning(String message, {String? tag, Object? error}) {
    _log('WARN', message, tag: tag, error: error);
  }

  /// Log errors with optional stack trace.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final prefix = tag != null ? '[$tag]' : '';
    final errorInfo = error != null ? ' | Error: $error' : '';
    final fullMessage = '$prefix $message$errorInfo';

    developer.log(
      fullMessage,
      name: '$_name:$level',
      error: error,
      stackTrace: stackTrace,
    );

    // Also print to console for visibility
    if (kDebugMode) {
      // ignore: avoid_print
      print('[$_name:$level]$prefix $message');
      if (error != null) {
        // ignore: avoid_print
        print('  └─ Error: $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('  └─ Stack: ${stackTrace.toString().split('\n').take(5).join('\n    ')}');
      }
    }
  }
}
