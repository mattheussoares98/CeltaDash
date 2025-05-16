import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ConfigurationsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> doLogout({
    required DepartmentsPresenter departmentsPresenter,
    required PaymentTypePresenter paymentTypePresenter,
    required SalesPresenter salesPresenter,
    required ProductsPresenter productsPresenter,
    required ResumePresenter resumePresenter,
    required HomePresenter homePresenter,
  });
}
