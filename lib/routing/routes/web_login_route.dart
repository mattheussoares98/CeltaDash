import 'package:go_router/go_router.dart';

import 'package:celta_dash/main/factories/factories.dart';
import 'package:celta_dash/routing/routes.dart';

RouteBase webLoginRoute() => GoRoute(
  path: '/web-login',
  name: Routes.webLogin.name,
  builder: (context, state) => makeWebLoginPage(),
);
