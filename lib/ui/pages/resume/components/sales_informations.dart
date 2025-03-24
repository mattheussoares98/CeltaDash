import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SalesInformations extends StatelessWidget {
  final String title;
  final double totalSales;
  final double goal;
  final List<Widget> children;
  final Widget leftButton;
  final Widget rightButton;
  final ScrollController scrollController;
  const SalesInformations({
    required this.title,
    required this.totalSales,
    required this.goal,
    required this.children,
    required this.leftButton,
    required this.rightButton,
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.decoration,
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
                        AnimatedCircleProgress(
                          value: totalSales,
                          maximum: goal,
                          width: 170,
                          height: 170,
                          scrollController: scrollController,
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: leftButton),
                const SizedBox(width: 8),
                Expanded(child: rightButton),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
