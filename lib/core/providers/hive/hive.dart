import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_dash/core/infrastructure/infrastructure.dart';

part 'hive.g.dart';

@Riverpod(keepAlive: true)
Box hiveBoxDash(Ref ref) {
  return Hive.box(DatabaseKeys.dash.name);
}
