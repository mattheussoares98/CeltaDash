import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

OperatorsProductivityPage makeOperatorsProductivityPage() =>
    OperatorsProductivityPage(
      presenter: makeGetxOperatorsProductivityPresenter(),
    );
