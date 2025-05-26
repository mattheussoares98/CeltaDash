import 'package:celta_plus/main/factories/factories.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

OperatorsProductivityPresenter makeGetxOperatorsProductivityPresenter() =>
    GetxOperatorsProductivityPresenter(
      loadSaleMovements: makeRemoteLoadSaleMovements(),
    );
