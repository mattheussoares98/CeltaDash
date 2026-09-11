import 'package:celta_dash/features/web_login/presentation/presentation.dart';
import 'package:celta_dash/routing/routes.dart';
import 'package:go_router/go_router.dart';

RouteBase webLoginRoute({required Future<bool> Function() isLoggedIn}) =>
    GoRoute(
      path: '/home/web-login',
      name: Routes.webLogin.name,
      redirect: (context, state) async {
        if (await isLoggedIn()) {
          return state.namedLocation(Routes.webEnterprises.name);
        }
        return null;
      },
      builder: (context, state) => const WebLoginPage(),
    );
