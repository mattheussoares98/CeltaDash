import '../../../../main/factories/pages/pages.dart';
import '../../../../ui/pages/pages.dart';

WebLoginPage makeWebLoginPage() => WebLoginPage(
      presenter: makeGetxWebLoginPresenter(),
    );
