import 'package:celta_dash/core/presentation/presentation.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'main/utils/utils.dart';

void main() async {
  await initApp();

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

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final router = ref.watch(goRouterProvider);

    debugPrint("largura: ${MediaQuery.of(context).size.width}");
    debugPrint("altura: ${MediaQuery.of(context).size.height}");

    return ToastificationWrapper(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: FocusScope.of(context).unfocus,
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
      ),
    );
  }
}
