import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CanceledSaleDetailsContent extends StatelessWidget {
  const CanceledSaleDetailsContent({required this.sale, super.key});

  final SaleMovementCollectionItemEntity sale;

  String _formatDate(DateTime? value) =>
      value == null ? '-' : DateFormat('dd/MM/yyyy HH:mm:ss').format(value);

  @override
  Widget build(BuildContext context) {
    final products = sale.products ?? const [];
    final finalizations = sale.paymentFinalizations ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BaseText.titleMedium('Cancelamento'.hardcoded),
        gapH8,
        TitleAndSubTitle(
          title: 'Data'.hardcoded,
          subTitle: _formatDate(sale.dateHourOfCancellation),
        ),
        TitleAndSubTitle(
          title: 'Cancelada por'.hardcoded,
          subTitle: sale.userCancellation,
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'Justificativa'.hardcoded,
          subTitle: sale.motiveCancellation,
          emptyMessage: '-'.hardcoded,
        ),
        gapH16,
        BaseText.titleMedium('Venda'.hardcoded),
        gapH8,
        TitleAndSubTitle(
          title: 'Data'.hardcoded,
          subTitle: _formatDate(sale.dateHourOfBilling),
        ),
        TitleAndSubTitle(
          title: 'PDV'.hardcoded,
          subTitle: sale.cashierNumber,
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'Cupom'.hardcoded,
          subTitle: sale.documentNumber,
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'Tipo'.hardcoded,
          subTitle: sale.fiscalNoteType?.Name,
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'Cliente'.hardcoded,
          subTitle: sale.customer?.Name,
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'CPF/CNPJ'.hardcoded,
          subTitle: sale.customer?.CpfCnpj,
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'Vendedor'.hardcoded,
          subTitle: sale.seller == null
              ? null
              : '${sale.seller?.PersonalizedCode ?? ''} - ${sale.seller?.Name ?? ''}',
          emptyMessage: '-'.hardcoded,
        ),
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitle: (sale.totalLiquid ?? 0).toString().toBRL(),
        ),
        if (products.isNotEmpty) ...[
          gapH16,
          BaseText.titleMedium('Produtos'.hardcoded),
          gapH8,
          for (final product in products)
            TitleAndSubTitle(
              title: product.Product?.Name ?? 'Produto'.hardcoded,
              subTitle:
                  '${product.Quantity ?? 0} × ${(product.UnitValueLiquid ?? 0).toString().toBRL()} = ${(product.TotalLiquid ?? 0).toString().toBRL()}',
            ),
        ],
        if (finalizations.isNotEmpty) ...[
          gapH16,
          BaseText.titleMedium('Finalizações'.hardcoded),
          gapH8,
          for (final finalization in finalizations)
            TitleAndSubTitle(
              title: finalization.Finalization?.Name ?? '-'.hardcoded,
              subTitle: (finalization.Value ?? 0).toString().toBRL(),
            ),
        ],
      ],
    );
  }
}
