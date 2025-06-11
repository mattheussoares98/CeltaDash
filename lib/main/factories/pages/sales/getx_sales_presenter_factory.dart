import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SalesPresenter makeGetxSalesPresenter() => GetxSalesPresenter(
      loadSaleStatistics: makeRemoteLoadSaleStatistics(),
    );
