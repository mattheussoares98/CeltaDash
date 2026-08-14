import 'package:package_info_plus/package_info_plus.dart';

import 'i_device_service.dart';

class DeviceService implements IDeviceService {
  @override
  Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (_) {
      return 'unrecognized';
    }
  }
}
