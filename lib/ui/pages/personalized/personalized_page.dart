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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Obx(() {
              final startDate =
                  widget.presenter.currentSelectedParams?.startDate;
              final endDate = widget.presenter.currentSelectedParams?.endDate;

              return Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 10,
                    margin: const EdgeInsets.fromLTRB(4, 8, 8, 20),
                    child: ExpansionTile(
                      controller: controller,
                      initiallyExpanded: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      dense: true,
                      title: Text(
                        R.string.parameters,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      children: [
                        const SelectPeriod(),
                        const SizedBox(height: 4),
                        if (startDate != null && endDate != null) ...[
                          const Enterprises(),
                          const SizedBox(height: 4),
                          const PeriodGrouping(),
                          const SizedBox(height: 4),
                          const CategoryGrouping(),
                          const SizedBox(height: 4),
                          GenerateButton(controller: controller),
                        ]
                      ],
                    ),
                  ),
                  // const PersonalizedPieChart(),
                ],
              );
            }),
          ),
          const PersonalizedTable(),
        ],
      ),
    );
  }
}
