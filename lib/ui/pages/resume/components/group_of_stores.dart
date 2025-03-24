import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import 'components.dart';

class GroupOfStores extends StatelessWidget {
  const GroupOfStores({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.decoration,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            R.string.groupOfStores,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(R.string.salesOfTheDay),
          //TODO add new chart
          DefaultNavigateButton(onTap: () {}, title: R.string.moreDetails),
        ],
      ),
    );
  }
}
