import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyboard_visibility_state_controller.g.dart';

@Riverpod(keepAlive: true)
class KeyboardVisibilityStateController
    extends _$KeyboardVisibilityStateController
    with WidgetsBindingObserver {
  @override
  bool build() {
    // PERFORMANCE: Registering as an observer allows us to react to system
    // metrics changes without rebuilding the entire widget tree via MediaQuery.
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));

    return _isKeyboardOpen();
  }

  @override
  void didChangeMetrics() {
    // When the keyboard slides up/down, system metrics change.
    final newValue = _isKeyboardOpen();
    if (state != newValue) {
      state = newValue;
    }
  }

  bool _isKeyboardOpen() {
    // View.of(context) inside build would be better, but in a controller,
    // we use PlatformDispatcher for a global-safe check.
    final bottomInset =
        PlatformDispatcher.instance.views.first.viewInsets.bottom;
    return bottomInset > 0;
  }
}

// Usage in any Widget:
// final isKeyboardVisible = ref.watch(keyboardVisibilityProvider);
