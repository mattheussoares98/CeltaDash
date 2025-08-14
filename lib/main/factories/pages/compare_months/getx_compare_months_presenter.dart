import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

CompareMonthsPresenter makeGetxCompareMonthsPresenter() =>
    GetxCompareMonthsPresenter(
      loadSaleStatistics: makeRemoteLoadSaleStatistics(),
    );
