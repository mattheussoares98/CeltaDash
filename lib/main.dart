import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';

import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import '../ui/mixins/mixins.dart';
import 'main/components/components.dart';
import 'main/utils/utils.dart';

void main() async {
  await initApp();

  runApp(const App());
}

bool _isFirstLoad = true;

class App extends StatelessWidget with KeyboardManager {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StringSize.updateStringSize(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    IsDarkTheme.updateIsDark(context);
    final routeObserver = Get.put(RouteObserver<PageRoute>());

    debugPrint("largura: ${MediaQuery.of(context).size.width}");
    debugPrint("altura: ${MediaQuery.of(context).size.height}");

    return GestureDetector(
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
        title: 'Celta Dash',
        debugShowCheckedModeBanner: false,
        theme: makeAppTheme(context),
        navigatorObservers: [routeObserver],
        initialRoute: PageRoutes.splash,
        routingCallback: (routing) {
          if (kIsWeb && _isFirstLoad) {
            _isFirstLoad = false;
            if (routing != null && routing.current != PageRoutes.splash) {
              Future.microtask(() => Get.offAllNamed(PageRoutes.splash));
            }
          }
        },
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
    );
  }
}
