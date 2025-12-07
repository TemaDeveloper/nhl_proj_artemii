import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  /// Log a debug message (verbose, for development only).
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[DEBUG]';
      debugPrint('$_cyan$prefix $_reset$message');
    }
  }

  /// Log an informational message.
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[INFO]';
      debugPrint('$_blue$prefix $_reset$message');
    }
  }

  /// Log a warning message.
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[WARNING]';
      debugPrint('$_yellow$prefix $_reset$message');
    }
  }

  /// Log an error message.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[ERROR]';
      debugPrint('$_red$prefix $_reset$message');
      
      if (error != null) {
        debugPrint('$_red  ↳ Error: $_reset$error');
      }
      
      if (stackTrace != null) {
        debugPrint('$_red  ↳ Stack:$_reset\n$stackTrace');
      }
    }
    
    // In production, send to crash reporting service
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// Log a success message.
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[SUCCESS]';
      debugPrint('$_green$prefix $_reset$message');
    }
  }

  /// Log a network request.
  static void network(String method, String url, {int? statusCode}) {
    if (kDebugMode) {
      final status = statusCode != null ? ' [$statusCode]' : '';
      debugPrint('$_magenta[NETWORK]$_reset $method $url$status');
    }
  }

  /// Log a Firestore query.
  static void firestore(String operation, String collection, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      final paramsStr = params != null ? ' ${params.toString()}' : '';
      debugPrint('$_cyan[FIRESTORE]$_reset $operation on $collection$paramsStr');
    }
  }

  /// Log a divider for better readability.
  static void divider() {
    if (kDebugMode) {
      debugPrint('$_magenta${'=' * 60}$_reset');
    }
  }

  /// Log a section header.
  static void section(String title) {
    if (kDebugMode) {
      divider();
      debugPrint('$_magenta  $title$_reset');
      divider();
    }
  }
}