import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../firebase_options.dart';
import '../../infra/helpers/helpers.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initFirebase();
  await _initHive();
  await _makeOnlyPortraitMode();
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(
    options: Platform.isIOS ? null : DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isIOS || Platform.isAndroid) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
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
      path = DatabaseKeys.dash.name;
    } else {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      path = appDocumentDir.path;
    }
    Hive.init(path);
    await Hive.openBox(DatabaseKeys.dash.name);
  } catch (e) {
    debugPrint(e.toString());
  }
}
