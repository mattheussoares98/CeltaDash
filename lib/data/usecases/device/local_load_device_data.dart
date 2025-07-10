import 'package:package_info_plus/package_info_plus.dart';

import '../../../domain/usecases/usecases.dart';

class LocalLoadDeviceData implements LoadDeviceData {
  @override
  Future<String> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return "unrecognized";
    }
  }
}
