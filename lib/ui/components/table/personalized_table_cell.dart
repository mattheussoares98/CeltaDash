import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class PersonalizedTableCell extends StatelessWidget {
  final dynamic value;
  final String? subtile;
  final bool? isMoney;
  final bool? isPercentage;
  final bool? isTitle;
  final void Function()? onTap;
  final BoxDecoration? decoration;
  const PersonalizedTableCell({
    super.key,
    required this.value,
    this.isMoney,
    this.subtile,
    this.isPercentage,
    this.isTitle,
    this.onTap,
    this.decoration,
  });

  String getName() {
    if (value is String) {
      return value;
    } else if (value is num && value % 1 == 0) {
      return value.toString().toBrazilianNumber(0);
    } else if (value is double) {
      var newValue = value as double;

      return newValue.toString().toBrazilianNumber();
    } else if (value is int) {
      return value.toString().toBrazilianNumber(0);
    }

    return "error";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  if (isMoney == true)
                    TextSpan(
                      text: 'R\$ ',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 10,
                          ),
                    ),
                  TextSpan(
                    text: getName(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: isTitle == true ? FontWeight.bold : null,
                        ),
                  ),
                  if (isPercentage == true)
                    TextSpan(
                      text: ' %',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 10,
                          ),
                    ),
                ],
              ),
            ),
            if (subtile != null)
              Text(
                subtile!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
