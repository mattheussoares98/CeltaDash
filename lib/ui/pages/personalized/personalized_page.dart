import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        child: Obx(() {
          final startDate = widget.presenter.currentSelectedParams?.startDate;
          final endDate = widget.presenter.currentSelectedParams?.endDate;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    if (startDate != null && endDate != null) ...[
                      const Enterprises(),
                      const PeriodGrouping(),
                      const CategoryGrouping(),
                      GenerateButton(controller: controller),
                    ]
                  ],
                ),
              ),
              if (startDate != null && endDate != null)
                Container(
                  decoration: ContainerDecoration.defaultDecoration,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          final formatter = DateFormat.yMd("pt_BR");

                          return Text(
                              "${formatter.format(startDate)} ~ ${formatter.format(endDate)}");
                        },
                      ),
                    ],
                  ),
                ),
              const PersonalizedPieChart(),
            ],
          );
        }),
      ),
    );
  }
}
