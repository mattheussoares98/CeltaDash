import 'package:celta_dash/features/canceled_sales/presentation/pages/pages.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase canceledSaleDetailsRoute() => GoRoute(
  path: '/home/bs-sale-details/:enterpriseId/:documentNumber/:billingTimestamp',
  name: Routes.bsSaleDetails.name,
  builder: (context, state) {
    return CanceledSaleDetailsPage(
      enterpriseId: int.parse(state.pathParameters['enterpriseId']!),
      documentNumber: state.pathParameters['documentNumber']!,
      billingDate: DateTime.fromMillisecondsSinceEpoch(
        int.parse(state.pathParameters['billingTimestamp']!),
      ),
    );
  },
);
