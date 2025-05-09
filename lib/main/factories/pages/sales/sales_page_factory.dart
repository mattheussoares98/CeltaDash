import '../../../../ui/pages/pages.dart';
import '../pages.dart';

SalesPage makeSalesPage() => SalesPage(
      presenter: makeGetxSalesPresenter(),
    );
