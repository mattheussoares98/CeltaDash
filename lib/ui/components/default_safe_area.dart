import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class DefaultSafeArea extends StatelessWidget {
  final Widget child;
  const DefaultSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isIos = Platform.isIOS;
    final nativeOrientation = NativeDeviceOrientationCommunicator();

    if (isIos) {
      return FutureBuilder(
          future: nativeOrientation.orientation(),
          builder: (context, orientation) {
            return SafeArea(
              left: orientation.data == NativeDeviceOrientation.landscapeLeft,
              right: orientation.data == NativeDeviceOrientation.landscapeRight,
              child: child,
            );
          });
    } else {
      return SafeArea(
        left: false,
        right: false,
        child: child,
      );
    }
  }
}
