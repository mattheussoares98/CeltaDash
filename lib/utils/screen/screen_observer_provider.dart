import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screen_observer_provider.g.dart';

class ScreenObserverState {
  const ScreenObserverState({
    required this.screenType,
    required this.width,
    required this.height,
  });

  final ScreenType screenType;
  final double width;
  final double height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenObserverState &&
          runtimeType == other.runtimeType &&
          screenType == other.screenType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => screenType.hashCode ^ width.hashCode ^ height.hashCode;
}

@riverpod
class ScreenObserver extends _$ScreenObserver with WidgetsBindingObserver {
  @override
  ScreenObserverState build() {
    final binding = WidgetsBinding.instance;
    binding.addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));

    ScreenUtil.I.configureScreen();
    return ScreenObserverState(
      screenType: ScreenUtil.I.type,
      width: ScreenUtil.I.width,
      height: ScreenUtil.I.height,
    );
  }

  @override
  void didChangeMetrics() {
    ScreenUtil.I.configureScreen();
    state = ScreenObserverState(
      screenType: ScreenUtil.I.type,
      width: ScreenUtil.I.width,
      height: ScreenUtil.I.height,
    );
  }
}
