import 'package:celta_dash/features/web_login/presentation/presentation.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_dash/routing/routes.dart';

RouteBase webLoginRoute() => GoRoute(
  path: '/home/web-login',
  name: Routes.webLogin.name,
  builder: (context, state) => const WebLoginPage(),
);
