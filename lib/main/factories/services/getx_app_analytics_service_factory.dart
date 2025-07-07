import '../../../ui/services/services.dart';
import '../../services/services.dart';
import '../factories.dart';

AppAnalyticsService makeGetxAppAnalyticsService() => GetxAppAnalyticsService(
      firebaseManager: makeRemoteFirebaseManager(),
      localStorage: makeHiveLocalStorage(),
    );
