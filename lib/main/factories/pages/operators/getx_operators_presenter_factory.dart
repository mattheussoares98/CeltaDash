import 'package:celta_dash/main/factories/factories.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

OperatorsPresenter makeGetxOperatorsPresenter() =>
    GetxOperatorsPresenter(
      ecLoadSaleStatistics: makeRemoteEcLoadSaleStatistics(),
    );
