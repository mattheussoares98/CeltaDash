import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebCustomersPage makeWebCustomersPage() => WebCustomersPage(
      presenter: makeGetxWebEnterprisesPresenter(),
    );
