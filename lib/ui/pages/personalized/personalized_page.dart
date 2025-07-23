import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/helpers/helpers.dart';
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

    final selectedCategoryGroupingType =
        _selectedCategoryGrouping(widget.presenter);
    final selectedPeriodGroupingType =
        _selectedPeriodGrouping(widget.presenter);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                  const Enterprises(),
                  const PeriodGrouping(),
                  const CategoryGrouping(),
                  GenerateButton(controller: controller),
                ],
              ),
            ),
            if (widget.presenter.startDate != null &&
                widget.presenter.endDate != null)
              Container(
                decoration: ContainerDecoration.defaultDecoration,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final formatter = DateFormat.yMd("pt_BR");
                        final startDate =
                            formatter.format(widget.presenter.startDate!);
                        final endDate =
                            formatter.format(widget.presenter.endDate!);

                        return Text("$startDate ~ $endDate");
                      },
                    ),
                    if (selectedPeriodGroupingType != null)
                      Text(selectedPeriodGroupingType.name),
                    if (selectedCategoryGroupingType != null)
                      Text(selectedCategoryGroupingType.name),
                  ],
                ),
              ),
            PersonalizedPieChart(
              selectedCategoryGroupingType: selectedCategoryGroupingType,
              selectedPeriodGroupingType: selectedPeriodGroupingType,
            ),
          ],
        ),
      ),
    );
  }
}

CategoryGroupingType? _selectedCategoryGrouping(
  PersonalizedPresenter presenter,
) {
  if (presenter.lastGetStatisticsParams?.groupByCashierOperator == true) {
    return CategoryGroupingType.cashierOperator;
  } else if (presenter.lastGetStatisticsParams?.groupByPaymentFinalization ==
      true) {
    return CategoryGroupingType.paymentFinalization;
  } else if (presenter.lastGetStatisticsParams?.groupByPaymentModality ==
      true) {
    return CategoryGroupingType.paymentModality;
  } else if (presenter.lastGetStatisticsParams?.groupByProduct == true) {
    return CategoryGroupingType.product;
  } else if (presenter.lastGetStatisticsParams?.groupByProductSection == true) {
    return CategoryGroupingType.productSection;
  } else if (presenter.lastGetStatisticsParams?.groupByProductDepartment ==
      true) {
    return CategoryGroupingType.productDepartment;
  } else if (presenter.lastGetStatisticsParams?.groupBySeller == true) {
    return CategoryGroupingType.seller;
  } else if (presenter.lastGetStatisticsParams?.groupByEnterprise == true) {
    return CategoryGroupingType.enterprise;
  }

  return null;
}

PeriodGroupingType? _selectedPeriodGrouping(
  PersonalizedPresenter presenter,
) {
  if (presenter.lastGetStatisticsParams?.groupByHour == true) {
    return PeriodGroupingType.hour;
  } else if (presenter.lastGetStatisticsParams?.groupByDay == true) {
    return PeriodGroupingType.day;
  } else if (presenter.lastGetStatisticsParams?.groupByMonth == true) {
    return PeriodGroupingType.month;
  } else if (presenter.lastGetStatisticsParams?.groupByYear == true) {
    return PeriodGroupingType.year;
  }
  return null;
}
