import 'package:go_router/go_router.dart';

import 'package:celta_dash/features/login/presentation/pages/pages.dart';
import 'package:celta_dash/routing/routes.dart';

RouteBase loginRoute() => GoRoute(
      path: '/login',
      name: Routes.login.name,
      builder: (context, state) => const LoginPage(),
    );
