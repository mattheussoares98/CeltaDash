import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sales/presentation/pages/sale_details/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class SaleContent extends StatelessWidget {
  const SaleContent({super.key, required this.sale});

  final SaleMovementCollectionItemEntity sale;

  @override
  Widget build(BuildContext context) {
    return BaseSaleTitleAndContent(
      title: 'Vendas'.hardcoded,
      content: Column(
        crossAxisAlignment: .stretch,
        children: [
          TitleAndSubTitle(
            title: 'Data'.hardcoded,
            subTitle: sale.dateHourOfBilling?.formatDate(.ddMMyyyyHHmmss),
          ),
          TitleAndSubTitle(
            title: 'PDV'.hardcoded,
            subTitle: sale.cashierNumber,
          ),
          TitleAndSubTitle(
            title: 'Cupom'.hardcoded,
            subTitle: sale.documentNumber,
          ),
          TitleAndSubTitle(
            title: 'Tipo'.hardcoded,
            subTitle: sale.fiscalNoteType?.Name,
          ),
          TitleAndSubTitle(
            title: 'Cliente'.hardcoded,
            subTitle: sale.customer?.Name,
          ),
          if (sale.customer?.CpfCnpj?.isNotEmpty ?? false)
            TitleAndSubTitle(
              title: 'CPF/CNPJ'.hardcoded,
              subTitle: sale.customer?.CpfCnpj,
            ),
          if (sale.seller != null)
            TitleAndSubTitle(
              title: 'Vendedor'.hardcoded,
              subTitle:
                  '${sale.seller?.PersonalizedCode ?? ''} - ${sale.seller?.Name ?? ''}',
            ),
          TitleAndSubTitle(
            title: 'Total'.hardcoded,
            subTitle: (sale.totalLiquid ?? 0).toString().toBRL(),
            subTitleIsPrice: true,
          ),
        ],
      ),
    );
  }
}
