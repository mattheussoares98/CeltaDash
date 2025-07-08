import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebAnalyticsPage makeWebAnalyticsPage() => WebAnalyticsPage(
      presenter: makeGetxWebAnalyticsPresenter(),
    );
