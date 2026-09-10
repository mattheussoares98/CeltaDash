import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase buyMovementHomeResumeRoute() => GoRoute(
  path: '/home/buy-movements/resume',
  name: Routes.buyMovementHomeResume.name,
  builder: (context, state) => const BuyMovementResumePage(),
);
