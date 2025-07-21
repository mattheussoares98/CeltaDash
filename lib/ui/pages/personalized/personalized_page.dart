import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'personalized.dart';

class PersonalizedPage extends StatefulWidget {
  final PersonalizedPresenter presenter;
  const PersonalizedPage({super.key, required this.presenter});

  @override
  State<PersonalizedPage> createState() => _PersonalizedPageState();
}

class _PersonalizedPageState extends State<PersonalizedPage> {
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: Text(
                  R.string.parameters,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                dense: true,
                expansionAnimationStyle: AnimationStyle.lerp(
                  const AnimationStyle(curve: Curves.linear),
                  const AnimationStyle(curve: Curves.bounceInOut),
                  2,
                ),
                visualDensity: VisualDensity.compact,
                children: [
                  SelectPeriod(
                    changeSelectedDateRange: (newDate) {
                      setState(() {
                        selectedDateRange = newDate;
                      });
                    },
                    selectedDateRange: selectedDateRange,
                  ),
                  const Enterprises(),
                  const GroupPeriod(),
                  const ExclusiveGrouping(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
