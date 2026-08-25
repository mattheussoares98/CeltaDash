import 'package:celta_dash/features/sales_features/sales/presentation/pages/pages.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase saleDetailsRoute() => GoRoute(
  path: '/home/bs-sale-details/:enterpriseId/:documentNumber/:billingTimestamp',
  name: Routes.bsSaleDetails.name,
  builder: (context, state) {
    return SaleDetailsPage(
      enterpriseId: int.parse(state.pathParameters['enterpriseId']!),
      documentNumber: state.pathParameters['documentNumber']!,
      billingDate: DateTime.fromMillisecondsSinceEpoch(
        int.parse(state.pathParameters['billingTimestamp']!),
      ),
    );
  },
);
