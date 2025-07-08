import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

AnalyticsPage makeAnalyticsPage() => AnalyticsPage(
      presenter: makeGetxAnalyticsPresenter(),
    );
