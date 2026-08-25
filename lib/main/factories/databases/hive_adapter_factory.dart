import 'package:hive/hive.dart';

import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import '../../../infra/databases/databases.dart';
import '../../../infra/helpers/helpers.dart';

HiveStorage makeHiveAdapter() => HiveAdapter(
        box: Hive.box(
      DatabaseKeys.dash.name,
    ));
