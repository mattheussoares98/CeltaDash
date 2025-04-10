import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

TeamPresenter makeGetxTeamPresenter() =>
    GetxTeamPresenter(navigateTo: makeGetxNavigateTo());
