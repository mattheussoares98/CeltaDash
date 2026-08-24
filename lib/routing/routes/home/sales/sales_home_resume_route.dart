import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase salesHomeResumeRoute(List<RouteBase> routes) => GoRoute(
  path: '/home/resume',
  name: Routes.salesHomeResume.name,
  builder: (context, state) => const ResumePage(),
  routes: routes,
);
