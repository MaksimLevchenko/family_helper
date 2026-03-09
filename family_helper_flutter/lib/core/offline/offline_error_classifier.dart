import 'dart:async';

import 'package:dio/dio.dart';

bool isOfflineRecoverableError(Object error) {
  if (error is TimeoutException) {
    return true;
  }

  if (error is DioException) {
    return error.type != DioExceptionType.badResponse;
  }

  final message = error.toString().toLowerCase();
  return message.contains('socketexception') ||
      message.contains('connection') ||
      message.contains('network') ||
      message.contains('timed out') ||
      message.contains('timeout');
}
