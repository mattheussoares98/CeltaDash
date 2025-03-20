import '../../ui/pages/pages.dart';
import '../factories/factories.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ListenableProvider<LoginPresenter>(create: (_) => makeGetxLoginPresenter()),
    ListenableProvider<SplashPresenter>(
      create: (_) => makeGetxSplashPresenter(),
    ),
  ];
}
