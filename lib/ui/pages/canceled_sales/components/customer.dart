import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class Customer extends StatelessWidget {
  const Customer({
    super.key,
    required this.sale,
  });

  final EcSaleMovementViewModel? sale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndValue(title: R.string.cpfCnpj, value: sale?.customer?.CpfCnpj),
        TitleAndValue(
            title: R.string.customer, value: sale?.customer?.Name ?? ""),
      ],
    );
  }
}
