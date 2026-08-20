import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/canceled_sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/canceled_sales/presentation/pages/canceled_sale_details/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanceledSaleDetailsPage extends ConsumerWidget {
  const CanceledSaleDetailsPage({
    required this.enterpriseId,
    required this.documentNumber,
    required this.billingDate,
    super.key,
  });

  final int enterpriseId;
  final String documentNumber;
  final DateTime billingDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = canceledSaleDetailsControllerProvider(
      enterpriseId,
      documentNumber,
      billingDate,
    );
    final saleAsync = ref.watch(provider);

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(title: 'Detalhes'.hardcoded),
      body: AsyncValueWidget(
        value: saleAsync,
        tryAgain: () => ref.invalidate(provider),
        data: (loadedSale) => CanceledSaleDetailsContent(sale: loadedSale),
      ),
    );
  }
}
