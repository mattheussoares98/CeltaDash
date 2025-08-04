import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

BsSalesPresenter makeGetxBsSalesPresenter() => GetxBsSalesPresenter(
      loadSaleMovements: makeRemoteLoadSaleMovements(),
      navigateTo: makeGetxNavigateTo(),
    );
