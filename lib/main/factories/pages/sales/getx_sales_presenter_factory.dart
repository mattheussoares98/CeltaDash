import '../../../../presentation/presenters/getx_sales_presenter.dart';
import '../../../../ui/pages/sales/sales_presenter.dart' show SalesPresenter;
import '../../factories.dart';

SalesPresenter makeGetxSalesPresenter() =>
    GetxSalesPresenter(loadSaleStatistics: makeRemoteLoadSaleStatistics());
