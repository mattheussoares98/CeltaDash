import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class MonthlyAnalysisSummary extends StatelessWidget {
  const MonthlyAnalysisSummary({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final num value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      BaseText.title(title, textAlign: TextAlign.center),
      BaseRichText(
        texts: [
          BaseText.caption('R\$ '),
          BaseText.title(value.toString().toBrazilianNumber()),
        ],
      ),
    ],
  );
}
