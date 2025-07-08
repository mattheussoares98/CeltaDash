import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebEnterprisesPage makeWebEnterprisesPage() => WebEnterprisesPage(
      webEnterprisesPresenter: makeGetxWebEnterprisesPresenter(),
      analyticsPresenter: makeGetxAnalyticsPresenter(),
    );
