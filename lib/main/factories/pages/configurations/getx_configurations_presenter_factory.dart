import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ConfigurationsPresenter makeGetxConfigurationsPresenter() =>
    GetxConfigurationsPresenter(
      navigateTo: makeGetxNavigateTo(),
      localStorage: makeHiveLocalStorage(),
    );
