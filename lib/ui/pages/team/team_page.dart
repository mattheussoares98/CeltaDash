import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class TeamPage extends StatelessWidget {
  final TeamPresenter presenter;
  const TeamPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(onChangeEnterprise: (_) {}),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultTitle(title: R.string.operators),
            DefaultButton(
              title: R.string.discounts,
              onTap: presenter.goToOperatorsDiscountsPage,
            ),
            DefaultButton(
              title: R.string.chargeBacks,
              onTap: presenter.goToOperatorsChargeBacksPage,
            ),
            DefaultButton(
              title: R.string.productivity,
              onTap: presenter.goToOperatorsProductivityPage,
            ),
            DefaultButton(
              title: R.string.sales,
              onTap: presenter.goToOperatorsSalesPage,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: DefaultTitle(title: R.string.sallers),
            ),
            DefaultButton(
              title: R.string.sales,
              onTap: presenter.goToSallersSalesPage,
            ),
          ],
        ),
      ),
    );
  }
}
