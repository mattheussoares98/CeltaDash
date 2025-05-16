import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebEnterprisesPresenter makeGetxWebEnterprisesPresenter() =>
    GetxWebEnterprisesPresenter(
      firebaseManager: makeRemoteFirebaseManager(),
      navigateTo: makeGetxNavigateTo(),
    );
