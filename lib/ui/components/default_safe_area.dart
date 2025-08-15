import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class DefaultSafeArea extends StatefulWidget {
  final Widget child;
  const DefaultSafeArea({super.key, required this.child});

  @override
  State<DefaultSafeArea> createState() => _DefaultSafeAreaState();
}

class _DefaultSafeAreaState extends State<DefaultSafeArea> {
  NativeDeviceOrientation? previousOrientation;

  @override
  Widget build(BuildContext context) {
    bool isIos = Platform.isIOS; //TODO remove this Platform from all app
    final nativeOrientation = NativeDeviceOrientationCommunicator();

    if (isIos) {
      return FutureBuilder(
          future: nativeOrientation.orientation(),
          //get the current orientation
          builder: (context, orientation) {
            return StreamBuilder(
                // Listen to orientation changes
                // and rebuild the widget when it changes
                stream: nativeOrientation.onOrientationChanged(
                    defaultOrientation:
                        orientation.data ?? NativeDeviceOrientation.portraitUp),
                builder: (context, asyncSnapshot) {
                  final currentOrientation =
                      asyncSnapshot.data ?? orientation.data;
                  return SafeArea(
                    left: currentOrientation ==
                        NativeDeviceOrientation.landscapeLeft,
                    right: currentOrientation ==
                        NativeDeviceOrientation.landscapeRight,
                    child: widget.child,
                  );
                });
          });
    } else {
      return SafeArea(
        child: widget.child,
      );
    }
  }
}
