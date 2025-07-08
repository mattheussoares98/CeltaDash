import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

AnalyticsPresenter makeGetxAnalyticsPresenter() =>
    GetxAnalyticsPresenter(firebaseManager: makeRemoteFirebaseManager());
