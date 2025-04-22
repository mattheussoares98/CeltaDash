import 'package:hive/hive.dart';

import '../../../data/database/database.dart';
import '../../../infra/databases/databases.dart';
import '../../../infra/helpers/helpers.dart';

HiveStorage makeHiveAdapter() => HiveAdapter(
        box: Hive.box(
      DatabaseKeys.dash.name,
    ));
