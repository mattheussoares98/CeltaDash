import '../../../../ui/pages/pages.dart';
import '../pages.dart';

ConfigurationsPage makeConfigurationsPage() => ConfigurationsPage(
      configurationsPresenter: makeGetxConfigurationsPresenter(),
    );
