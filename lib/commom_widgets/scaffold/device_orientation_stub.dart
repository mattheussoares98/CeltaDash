// lib/commom_widgets/scaffold/device_orientation_stub.dart
import 'package:flutter/widgets.dart';

enum NativeDeviceOrientation {
  portraitUp,
  portraitDown,
  landscapeLeft,
  landscapeRight,
  unknown,
}

Widget buildOrientationReader({
  required Widget Function(BuildContext context) builder,
  bool useSensor = true,
}) {
  return Builder(builder: builder);
}

class NativeDeviceOrientationReaderWrapper {
  static NativeDeviceOrientation orientation(BuildContext context) {
    return NativeDeviceOrientation.unknown;
  }
}
