import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebAnalyticsPresenter makeGetxWebAnalyticsPresenter() =>
    GetxWebAnalyticsPresenter(firebaseManager: makeRemoteFirebaseManager());
