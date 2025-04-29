import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

PaymentTypePage makePaymentsTypePage() => PaymentTypePage(
      paymentTypePresenter: makeGetxPaymentTypePresenter(),
    );
