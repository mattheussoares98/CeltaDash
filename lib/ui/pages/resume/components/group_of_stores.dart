import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class GroupOfStores extends StatelessWidget {
  const GroupOfStores({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);

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
          ChartPie(
            pieParameters: [
              PieParameter(
                value: Random().nextDouble() * 50000,
                title: faker.company.name(),
              ),
              PieParameter(
                value: Random().nextDouble() * 50000,
                title: faker.company.name(),
              ),
              PieParameter(
                value: Random().nextDouble() * 50000,
                title: faker.company.name(),
              ),
              PieParameter(
                value: Random().nextDouble() * 50000,
                title: faker.company.name(),
              ),
              PieParameter(
                value: Random().nextDouble() * 50000,
                title: faker.company.name(),
              ),
            ],
          ),
          DefaultNavigateButton(
            onTap: resumePresenter.goToGroupSummaryPage,
            title: R.string.moreDetails,
          ),
        ],
      ),
    );
  }
}
