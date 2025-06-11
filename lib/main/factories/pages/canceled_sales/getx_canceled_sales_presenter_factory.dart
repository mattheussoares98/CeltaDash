import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

CanceledSalesPresenter makeGetxCanceledSalesPresenter() =>
    GetxCanceledSalesPresenter(
      loadSaleMovements: makeRemoteLoadSaleMovements(),
      navigateTo: makeGetxNavigateTo(),
    );
