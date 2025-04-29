import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

PaymentTypePresenter makeGetxPaymentTypePresenter() => GetxPaymentTypePresenter(
      loadSaleMovements: makeRemoteLoadSaleMovements(),
    );
