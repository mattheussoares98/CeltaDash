import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebEnterprisesPage makeWebEnterprisesPage() => WebEnterprisesPage(
      presenter: makeGetxWebEnterprisesPresenter(),
    );
