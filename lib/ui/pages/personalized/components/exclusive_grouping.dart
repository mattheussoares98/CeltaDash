import 'package:flutter/material.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class ExclusiveGrouping extends StatelessWidget {
  const ExclusiveGrouping({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultExpansionTile(
      title: R.string.exclusiveGrouping,
      children: ExclusiveGroupingType.values
          .map((e) => CheckBoxItem(
                title: e.name,
                onTap: () {
                  //TODO implement
                },
              ))
          .toList(),
    );
  }
}
