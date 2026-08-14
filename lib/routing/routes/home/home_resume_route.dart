import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase homeResumeRoute() => GoRoute(
  path: '/home/resume',
  name: Routes.homeResume.name,
  builder: (context, state) => const ResumePage(),
);
