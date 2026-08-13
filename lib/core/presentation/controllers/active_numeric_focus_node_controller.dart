// lib/core/presentation/controllers/keyboard/keyboard/active_numeric_focus_node_controller.dart

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_numeric_focus_node_controller.g.dart';

@riverpod
class ActiveNumericFocusNode extends _$ActiveNumericFocusNode {
  @override
  FocusNode? build() {
    return null;
  }

  void setActiveNode(FocusNode? node) {
    state = node;
  }

  void clearIfActive(FocusNode? node) {
    if (state == node) {
      state = null;
    }
  }
}
