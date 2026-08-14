import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main/utils/utils.dart';
import 'ui/themes/theme.dart';

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

class App extends HookConsumerWidget with KeyboardManager {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StringSize.updateStringSize(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    IsDarkTheme.updateIsDark(context);

    final router = ref.watch(goRouterProvider);

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
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Celta Dash',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: .light, //TODO enable changing the theme
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
