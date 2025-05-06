import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class Indicator extends StatelessWidget {
  final String firstTitle;
  final String firstValue;
  final String secondTitle;
  final String secondValue;
  final IconData icon;
  const Indicator({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.firstValue,
    required this.secondValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.decoration,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(firstTitle),
                Text(
                  firstValue,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(secondTitle),
                Text(
                  secondValue,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
