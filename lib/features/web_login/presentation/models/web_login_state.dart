import 'package:equatable/equatable.dart';

class WebLoginState extends Equatable {
  final bool isAuthenticated;
  final bool isSubmitting;
  final Object? actionError;

  const WebLoginState({
    this.isAuthenticated = false,
    this.isSubmitting = false,
    this.actionError,
  });

  WebLoginState copyWith({
    bool? isAuthenticated,
    bool? isSubmitting,
    Object? actionError,
    bool clearActionError = false,
  }) => WebLoginState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    actionError: clearActionError ? null : actionError ?? this.actionError,
  );

  @override
  List<Object?> get props => [isAuthenticated, isSubmitting, actionError];
}
