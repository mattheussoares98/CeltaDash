import 'dart:async';

import '../../main/utils/utils.dart';
import '../components/components.dart';
import '../helpers/errors/errors.dart';

import 'package:flutter/material.dart';

mixin UIErrorManager {
  StreamSubscription handleMainError(
      BuildContext context, Stream<UIError?> stream) {
    //TODO remove this unecessary parameter
    final streamSubscription = stream.listen((error) {
      if (error != null) {
        showErrorMessage(NavigatorKey.key.currentState?.context ?? context,
            error.description);
      }
    });
    return streamSubscription;
  }
}
