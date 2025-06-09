import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

DepartmentsPresenter makeGetxDepartmentsPresenter() => GetxDepartmentsPresenter(
      ecLoadSaleStatistics: makeRemoteEcLoadSaleStatistics(),
    );
