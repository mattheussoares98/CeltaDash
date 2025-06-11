import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Products extends StatelessWidget {
  const Products({
    super.key,
    required this.sale,
  });

  final EcSaleMovementViewModel? sale;

  @override
  Widget build(BuildContext context) {
    if (sale?.products?.isEmpty == true) return SizedBox();

    return Column(
      children: [
        TableItem(
          columnsIndexToSum: [3],
          indexToSort: 0,
          titleMinHeight: 30,
          tableColumnWidth: {
            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.25),
          },
          titles: [
            PersonalizedTableCell(value: R.string.product),
            PersonalizedTableCell(value: R.string.quantityAbbreviated),
            PersonalizedTableCell(value: R.string.price),
            PersonalizedTableCell(value: R.string.total),
          ],
          rowValues: sale!.products!.map((e) {
            return [
              PersonalizedTableCell(value: e.Product?.Name ?? ""),
              PersonalizedTableCell(value: e.Quantity?.toDouble()),
              PersonalizedTableCell(
                value: e.UnitValueLiquid?.toDouble(),
                isMoney: true,
              ),
              PersonalizedTableCell(
                value: e.TotalLiquid?.toDouble(),
                isMoney: true,
              ),
            ];
          }).toList(),
        ),
      ],
    );
  }
}
