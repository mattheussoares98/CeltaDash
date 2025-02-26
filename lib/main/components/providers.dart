import '../../ui/pages/pages.dart';
import '../factories/factories.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ListenableProvider<SplashPresenter>(
      create: (_) => makeGetxSplashPresenter(),
    ),
  ];
}
