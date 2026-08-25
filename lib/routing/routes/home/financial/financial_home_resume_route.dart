import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase financialHomeResumeRoute() => GoRoute(
  path: '/home/financial/resume',
  name: Routes.financialHomeResume.name,
  builder: (context, state) => const FinancialResumePage(),
);

