import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SalesInformations extends StatelessWidget {
  final String title;
  final double totalSales;
  final double? goal;
  final List<Widget>? rightChildren;
  final List<Widget>? topChildren;
  final List<Widget>? bottomChildren;
  final DefaultButton? leftButton;
  final DefaultButton? rightButton;
  final ScrollController scrollController;
  const SalesInformations({
    required this.title,
    required this.totalSales,
    this.goal,
    this.rightChildren,
    this.topChildren,
    this.bottomChildren,
    this.leftButton,
    this.rightButton,
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 10),
            if (topChildren != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: topChildren!,
              ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: goal == null ? 170 : 200,
                    height: goal == null ? 170 : 200,
                    child: Column(
                      children: [
                        AnimatedCircleProgress(
                          value: totalSales,
                          maximum: goal ?? totalSales,
                          width: 170,
                          height: 170,
                          scrollController: scrollController,
                        ),
                        if (goal != null && goal! > 0)
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
                if (rightChildren != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: rightChildren!,
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (leftButton != null) Expanded(child: leftButton!),
                const SizedBox(width: 8),
                if (rightButton != null) Expanded(child: rightButton!),
              ],
            ),
            if (bottomChildren != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bottomChildren!,
              ),
          ],
        ),
      ),
    );
  }
}
