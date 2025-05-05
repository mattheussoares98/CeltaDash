import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

CompareDaysPresenter makeGetxCompareDaysPresenter() => GetxCompareDaysPresenter(
      loadSaleMovements: makeRemoteLoadSaleMovements(),
    );
