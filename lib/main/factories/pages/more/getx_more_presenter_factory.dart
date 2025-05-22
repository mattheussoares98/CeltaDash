import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

MorePresenter makeGetxMorePresenter() =>
    GetxMorePresenter(
      navigateTo: makeGetxNavigateTo(),
      localStorage: makeHiveLocalStorage(),
    );
