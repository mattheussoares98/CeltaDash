import 'package:celta_dash/features/web_enterprises/presentation/presentation.dart';
import 'package:celta_dash/routing/routes.dart';
import 'package:go_router/go_router.dart';

RouteBase webEnterprisesRoute() => GoRoute(
  path: '/home/web-enterprises',
  name: Routes.webEnterprises.name,
  builder: (context, state) => const WebEnterprisesPage(),
);
