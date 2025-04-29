import '../../ui/pages/pages.dart';
import '../factories/factories.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ListenableProvider<HomePresenter>(create: (_) => makeGetxHomePresenter()),
    ListenableProvider<LoginPresenter>(create: (_) => makeGetxLoginPresenter()),
    ListenableProvider<ResumePresenter>(
      create: (_) => makeGetxResumePresenter(),
    ),
    ListenableProvider<SplashPresenter>(
      create: (_) => makeGetxSplashPresenter(),
    ),
  ];
}
