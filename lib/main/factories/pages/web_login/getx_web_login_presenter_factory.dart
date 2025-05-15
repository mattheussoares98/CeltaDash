import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebLoginPresenter makeGetxWebLoginPresenter() => GetxWebLoginPresenter(
    firebaseLoginManagement: makeWebFirebaseLoginManagement(),
    navigateTo: makeGetxNavigateTo());
