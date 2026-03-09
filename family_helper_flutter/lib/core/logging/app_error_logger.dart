import 'package:flutter/foundation.dart';

class AppErrorLogger {
  const AppErrorLogger._();

  static void logHandled({
    required String scope,
    required Object error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    _log(
      kind: 'handled',
      scope: scope,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      context: context,
    );
  }

  static void logUnhandled({
    required String scope,
    required Object error,
    required StackTrace stackTrace,
    Map<String, Object?>? context,
  }) {
    _log(
      kind: 'unhandled',
      scope: scope,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  static void _log({
    required String kind,
    required String scope,
    required Object error,
    required StackTrace stackTrace,
    Map<String, Object?>? context,
  }) {
    final buffer = StringBuffer()
      ..writeln('[ERROR] [$kind] scope=$scope')
      ..writeln('type=${error.runtimeType}')
      ..writeln('message=$error');
    if (context != null && context.isNotEmpty) {
      buffer.writeln('context=${_formatContext(context)}');
    }
    buffer.writeln('stackTrace:\n$stackTrace');

    _printChunked(buffer.toString());
  }

  static String _formatContext(Map<String, Object?> context) {
    return context.entries.map((e) => '${e.key}=${e.value}').join(', ');
  }

  static void _printChunked(String message) {
    const chunkSize = 800;
    for (var i = 0; i < message.length; i += chunkSize) {
      final end = (i + chunkSize < message.length)
          ? i + chunkSize
          : message.length;
      debugPrint(message.substring(i, end));
    }
  }
}
