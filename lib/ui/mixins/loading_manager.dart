import 'dart:async';

import '../components/components.dart';

import 'package:flutter/material.dart';

mixin LoadingManager {
  StreamSubscription handleLoading(BuildContext context, Stream<bool> stream) {
    final streamSubscription = stream.listen((isLoading) {
      if (isLoading == true) {
        showLoading(context);
      } else {
        hideLoading(context);
      }
    });

    return streamSubscription;
  }
}
