import 'dart:io';

import 'package:celta_plus/domain/helpers/platform_type.dart';

import '../../../domain/usecases/usecases.dart';

class LocalGetPlatform implements GetPlatformType {
  @override
  PlatformType get() {
    try {
      if (Platform.isAndroid) {
        return PlatformType.android;
      } else if (Platform.isIOS) {
        return PlatformType.ios;
      } else if (Platform.isWindows) {
        return PlatformType.windows;
      } else {
        return PlatformType.web;
      }
    } catch (e) {
      return PlatformType.android;
    }
  }
}
