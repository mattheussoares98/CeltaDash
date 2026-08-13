import 'package:celta_dash/exceptions/app_exception.dart';
import 'package:celta_dash/exceptions/error_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controllers in the app
base class AsyncErrorLogger extends ProviderObserver {
  final _errorLogger = ErrorLogger();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    final error = _findError(value);
    if (error != null) {
      final providerName =
          context.provider.name ?? context.provider.runtimeType.toString();
      debugPrint('⚠️ Provider Error (Add) in: [$providerName]');
      if (error.error is AppException) {
        _errorLogger.logAppException(error.error as AppException);
      } else {
        _errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final error = _findError(newValue);
    if (error != null) {
      final providerName =
          context.provider.name ?? context.provider.runtimeType.toString();
      debugPrint('⚠️ Provider Error (Update) in: [$providerName]');
      if (error.error is AppException) {
        // only prints the AppException data
        _errorLogger.logAppException(error.error as AppException);
      } else {
        // prints everything including the stack trace
        _errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final providerName =
        context.provider.name ?? context.provider.runtimeType.toString();
    debugPrint('⚠️ Provider Error (Fail) in: [$providerName]');
    if (error is AppException) {
      _errorLogger.logAppException(error);
    } else {
      _errorLogger.logError(error, stackTrace);
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
