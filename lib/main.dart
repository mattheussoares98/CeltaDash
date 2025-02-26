import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import '../ui/mixins/mixins.dart';
import 'main/components/components.dart';
import 'main/utils/utils.dart';

void main() async {
  await initInjections();

  runApp(const App());
}

class App extends StatelessWidget with KeyboardManager {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StringSize.updateStringSize(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    debugPrint("largura: ${MediaQuery.of(context).size.width}");
    debugPrint("altura: ${MediaQuery.of(context).size.height}");

    return MultiProvider(
      providers: Providers.providers,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          hideKeyboard(context);
        },
        onPanDown: (_) {
          FocusScope.of(context).unfocus();
          hideKeyboard(context);
        },
        child: GetMaterialApp(
          navigatorKey: NavigatorKey.key,
          title: 'Celta plus',
          debugShowCheckedModeBanner: false,
          theme: makeAppTheme(context),
          navigatorObservers: [routeObserver],
          initialRoute: PageRoutes.splash,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          getPages: GetPages.getPages,
        ),
      ),
    );
  }
}
