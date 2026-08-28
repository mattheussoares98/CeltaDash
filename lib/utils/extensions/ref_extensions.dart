import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension RefExtensions on Ref {
  void invalidatePeriodically([int seconds = 300]) {
    if (seconds <= 0) {
      throw ArgumentError.value(
        seconds,
        'seconds',
        'Must be greater than zero.',
      );
    }

    Timer? invalidateTimer;

    void startTimer() {
      invalidateTimer?.cancel();
      invalidateTimer = Timer.periodic(
        Duration(seconds: seconds),
        (_) => invalidateSelf(),
      );
    }

    startTimer();
    onCancel(() => invalidateTimer?.cancel());
    onResume(startTimer);
    onDispose(() => invalidateTimer?.cancel());
  }

  void cache([int seconds = 60]) {
    Timer? disposeTimer;
    final link = keepAlive();

    onCancel(() {
      disposeTimer?.cancel();
      disposeTimer = Timer(Duration(seconds: seconds), link.close);
    });
    onResume(() {
      disposeTimer?.cancel();
      disposeTimer = null;
    });
    onDispose(() {
      disposeTimer?.cancel();
    });
  }
}
