import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

DepartmentsPage makeDepartmentsPage() => DepartmentsPage(
      departmentsPresenter: makeGetxDepartmentsPresenter(),
    );
