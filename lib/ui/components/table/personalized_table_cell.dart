import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class PersonalizedTableCell extends StatelessWidget {
  final dynamic value;
  final String? subtile;
  final bool? isMoney; //TODO move to title
  final bool? isPercentage; //TODO move to title
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final void Function()? onTap;
  const PersonalizedTableCell({
    super.key,
    required this.value,
    this.isMoney,
    this.subtile,
    this.isPercentage,
    this.titleStyle,
    this.subtitleStyle,
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getName(),
                textAlign: TextAlign.center,
                style:
                    titleStyle ??
                    TextStyle(
                      fontSize: 12,
                      fontWeight:
                          subtile == null ? FontWeight.normal : FontWeight.bold,
                    ),
              ),
              if (subtile != null)
                Text(
                  subtile!,
                  style:
                      subtitleStyle ??
                      TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
