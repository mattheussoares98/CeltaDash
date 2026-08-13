import 'dart:developer' as developer;

import 'package:celta_dash/exceptions/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace, {String? reason}) {
    final truncatedError = _truncateError(error);
    final truncatedStack = _truncateStackTrace(stackTrace);

    // * This can be replaced with a call to a crash reporting tool of choice
    developer.log(
      reason ?? 'Starting the LOG error from ErrorLogger',
      error: truncatedError,
      stackTrace: truncatedStack,
    );
  }

  void logAppException(AppException exception) {
    final truncatedException = _truncateError(exception);
    // * This can be replaced with a call to a crash reporting tool of choice
    developer.log(
      'Starting the LOG exception from ErrorLogger',
      error: truncatedException,
    );
  }

  String _truncateError(Object error, {int maxLength = 500}) {
    final str = error.toString();
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}... [TRUNCATED]';
  }

  StackTrace? _truncateStackTrace(StackTrace? stackTrace, {int maxLines = 15}) {
    if (stackTrace == null) return null;
    final stackStr = stackTrace.toString();
    final lines = stackStr.split('\n');
    if (lines.length <= maxLines) return stackTrace;
    return StackTrace.fromString(lines.take(maxLines).join('\n'));
  }
}

@riverpod
ErrorLogger errorLogger(Ref ref) {
  return ErrorLogger();
}
