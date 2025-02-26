import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../infra/helpers/helpers.dart';

Future<void> initInjections() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initHive();
  await _makeOnlyPortraitMode();
}



Future<void> _makeOnlyPortraitMode() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> _initHive() async {
  String? path;

  try {
    if (kIsWeb) {
      path = DatabaseKeys.hiveBoxName.name;
    } else {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      path = appDocumentDir.path;
    }
    Hive.init(path);
    await Hive.openBox(DatabaseKeys.hiveBoxName.name);
  } catch (e) {
    debugPrint(e.toString());
  }
}
