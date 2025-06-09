import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SellersPresenter makeGetxSellersPresenter() => GetxSellersPresenter(
      ecLoadSaleStatistics: makeRemoteEcLoadSaleStatistics(),
    );
