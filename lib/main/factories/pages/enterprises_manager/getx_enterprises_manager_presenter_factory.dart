import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

EnterprisesManagerPresenter makeGetxEnterprisesManagerPresenter() =>
    GetxEnterprisesManagerPresenter(
      navigateTo: makeGetxNavigateTo(),
      bsLogin: makeRemoteBsLogin(),
      firebaseManager: makeRemoteFirebaseManager(),
      localStorage: makeHiveLocalStorage(),
    );
