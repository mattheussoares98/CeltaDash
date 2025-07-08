import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

AppAnalyticsPresenter makeGetxAnalyticsPresenter() =>
    GetxAnalyticsPresenter(firebaseManager: makeRemoteFirebaseManager());
