import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class PersonalizedTableCell extends StatelessWidget {
  final dynamic value;
  final bool? isMoney;
  final bool? isPercentage;
  final TextStyle? style;
  final void Function()? onTap;
  const PersonalizedTableCell({
    super.key,
    required this.value,
    this.isMoney,
    this.isPercentage,
    this.style,
    this.onTap,
  });

  String getName() {
    if (value is String) {
      return value;
    } else if (value is double) {
      var newValue = value as double;
      if (isMoney == true) {
        return newValue.toString().toBrazilianNumber().addBrazilianCoin();
      } else if (isPercentage == true) {
        return '${newValue.toString().toBrazilianNumber()}%';
      }
      return newValue.toString().toBrazilianNumber();
    } else if (value is int) {
      return value.toString();
    } else {
      throw Exception("Write String, double or int type");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(3),
          child: Center(
            child: Text(
              getName(),
              textAlign: TextAlign.center,
              style: style ?? TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
