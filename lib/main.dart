import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import '../ui/mixins/mixins.dart';
import 'main/components/components.dart';
import 'main/utils/utils.dart';

void main() async {
  await initApp();

  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  // * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [],
    observers: [/* AsyncErrorLogger() */],
  );
  // * Initialize CartSyncService to start the listener
  // final errorLogger = container.read(errorLoggerProvider);
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  // registerErrorHandlers(errorLogger);
  // * Entry point of the app
  runApp(UncontrolledProviderScope(container: container, child: const App()));
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
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        getPages: GetPages.getPages,
      ),
    );
  }
}
