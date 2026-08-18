import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension RefCacheExtension on Ref {
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
