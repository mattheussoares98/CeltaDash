import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ProductsPresenter makeGetxProductsPresenter() => GetxProductsPresenter(
      loadSaleStatistics: makeRemoteLoadSaleStatistics(),
      localStorage: makeHiveLocalStorage(),
    );
