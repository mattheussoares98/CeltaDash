import 'package:flutter/material.dart';

class SalesInformations extends StatelessWidget {
  final String title;
  final String chartTitle;
  final List<Widget> children;
  final Widget leftButton;
  final Widget rightButton;
  const SalesInformations({
    required this.title,
    required this.chartTitle,
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
            Text(title.toUpperCase(), style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: CircleAvatar(
                    minRadius: 50,
                    maxRadius: 50,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(chartTitle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
