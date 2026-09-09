// lib/commom_widgets/scaffold/device_orientation_mobile.dart
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:native_device_orientation/native_device_orientation.dart'
    as native;

export 'package:native_device_orientation/native_device_orientation.dart'
    show NativeDeviceOrientation;

Widget buildOrientationReader({
  required Widget Function(BuildContext context) builder,
  bool useSensor = true,
}) {
  if (PlatformUtil.isIOS) {
    return native.NativeDeviceOrientationReader(
      useSensor: useSensor,
      builder: builder,
    );
  }
  return Builder(builder: builder);
}

class NativeDeviceOrientationReaderWrapper {
  static native.NativeDeviceOrientation orientation(BuildContext context) {
    if (PlatformUtil.isIOS) {
      try {
        return native.NativeDeviceOrientationReader.orientation(context);
      } catch (_) {
        return native.NativeDeviceOrientation.unknown;
      }
    }
    return native.NativeDeviceOrientation.unknown;
  }
}
