import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class PersonalizedPage extends StatefulWidget {
  final PersonalizedPresenter presenter;
  const PersonalizedPage({super.key, required this.presenter});

  @override
  State<PersonalizedPage> createState() => _PersonalizedPageState();
}

class _PersonalizedPageState extends State<PersonalizedPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;
  DateTimeRange? selectedDateRange;
  final controller = ExpansibleController();

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);
    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
  }

  @override
  Widget build(BuildContext context) {
    Get.put<PersonalizedPresenter>(widget.presenter);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                controller: controller,
                initiallyExpanded: true,
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
                  const SelectPeriod(),
                  const Enterprises(),
                  const PeriodGrouping(),
                  const CategoryGrouping(),
                  GenerateButton(controller: controller),
                ],
              ),
            ),
            const PersonalizedPieChart()
          ],
        ),
      ),
    );
  }
}
