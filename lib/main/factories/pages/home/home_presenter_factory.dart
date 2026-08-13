import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

HomePresenter makeGetxHomePresenter() => GetxHomePresenter(
      navigateTo: makeGetxNavigateTo(),
      loadEnterprises: makeRemoteLoadEnterprises(),
      firebaseManager: makeRemoteFirebaseManager(),
      localStorage: makeHiveLocalStorage(),
      manageAppMode: makeLocalManageAppMode(),
    );
