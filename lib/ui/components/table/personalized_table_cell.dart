import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class PersonalizedTableCell extends StatelessWidget {
  final dynamic value;
  final String? subtile;
  final bool? isMoney;
  final bool? isPercentage;
  final bool? isTitle;
  final void Function()? onTap;
  final List<Widget>? children;
  const PersonalizedTableCell({
    super.key,
    required this.value,
    this.isMoney,
    this.subtile,
    this.isPercentage,
    this.isTitle,
    this.onTap,
    this.children,
  });

  String getName() {
    if (value is String) {
      return value;
    }

    if (value is double) {
      var newValue = value as double;

      return newValue.toString().toBrazilianNumber();
    }

    if (value is int) {
      return value.toString();
    }

    throw Exception("Write String, double or int type");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  TextSpan(
                    text: getName(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: isTitle == true ? FontWeight.bold : null,
                    ),
                  ),
                  if (isPercentage == true)
                    TextSpan(
                      text: ' %',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            if (subtile != null)
              Text(
                subtile!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
