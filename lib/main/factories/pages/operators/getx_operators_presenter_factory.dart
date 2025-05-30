import 'package:celta_plus/main/factories/factories.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

OperatorsPresenter makeGetxOperatorsPresenter() =>
    GetxOperatorsPresenter(
      loadSaleMovements: makeRemoteLoadSaleMovements(),
    );
