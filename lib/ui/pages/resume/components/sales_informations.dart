import 'package:flutter/material.dart';

import '../../../../ui/helpers/convert/convert.dart';
import '../../../components/components.dart';

class SalesInformations extends StatelessWidget {
  final String title;
  final double totalSales;
  final double goal;
  final List<Widget> children;
  final Widget leftButton;
  final Widget rightButton;
  const SalesInformations({
    required this.title,
    required this.totalSales,
    required this.goal,
    required this.children,
    required this.leftButton,
    required this.rightButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            offset: Offset(2, 2), // horizontal and vertical offset
            blurRadius: 1,
          ),
          BoxShadow(
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            offset: Offset(-2, -2),
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Column(
                      children: [
                        CircleProgress(
                          value: totalSales,
                          maximum: goal,
                          width: 170,
                          height: 170,
                        ),
                        SizedBox(
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: FittedBox(
                              child: Text(
                                "Goal: ${goal.toString().toBrazilianNumber().addBrazilianCoin()}",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: leftButton),
                Expanded(child: rightButton),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
