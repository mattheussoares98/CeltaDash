import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../presentation/mocks/mocks.dart';
import '../mocks/mocks.dart';

Widget makePage({
  required String path,
  required Widget Function() page,
  dynamic arguments,
}) {
  Get.put<EnterprisesManagerPresenter>(EnterprisesManagerPresenterSpy());

  final allPages = [
    GetPage(
      name: '/any_route',
      page: () => Scaffold(
        appBar: AppBar(title: const Text('any title')),
        body: const Text('fake page'),
      ),
    ),
    GetPage(
      name: PageRoutes.login,
      page: () => LoginPage(presenter: LoginPresenterSpy()),
    ),
    GetPage(
      name: PageRoutes.enterprisesManager,
      page: () => const EnterprisesManagerPage(),
    ),
    GetPage(
      name: PageRoutes.splash,
      page: () => SplashPage(presenter: SplashPresenterSpy()),
    ),
  ];

  final index = allPages.indexWhere((element) => element.name == path);
  if (index != -1) {
    //precisa sobrescrever a página que já existe caso esteja tentando criar ela
    //novamente pra não dar erro nos testes
    allPages[index] = GetPage(name: path, page: page, arguments: arguments);
  } else {
    allPages.add(GetPage(name: path, page: page, arguments: arguments));
  }

  _createGetPresenters();

  return GetMaterialApp(
    initialRoute: path,
    navigatorObservers: [Get.put<RouteObserver>(RouteObserver<PageRoute>())],
    getPages: allPages,
  );
}

String get currentRoute => Get.currentRoute;

void _createGetPresenters() {
  Get.put<SplashPresenter>(SplashPresenterSpy());
  Get.put<LoginPresenter>(LoginPresenterSpy());
}
