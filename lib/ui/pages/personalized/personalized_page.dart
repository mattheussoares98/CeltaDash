import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        _selectedCategoryGrouping(widget.presenter.saleStatistics ?? []);
    final selectedPeriodGroupingType =
        _selectedPeriodGrouping(widget.presenter.saleStatistics ?? []);

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
  List<SaleStatisticViewModel> sales,
) {
  if (sales.any((e) => e.CashierOperator != null)) {
    return CategoryGroupingType.cashierOperator;
  } else if (sales.any((e) => e.PaymentFinalization != null)) {
    return CategoryGroupingType.paymentFinalization;
  } else if (sales.any((e) => e.PaymentModality != null)) {
    return CategoryGroupingType.paymentModality;
  } else if (sales.any((e) => e.Product != null)) {
    return CategoryGroupingType.product;
  } else if (sales.any((e) => e.ProductSection != null)) {
    return CategoryGroupingType.productSection;
  } else if (sales.any((e) => e.ProductDepartment != null)) {
    return CategoryGroupingType.productDepartment;
  } else if (sales.any((e) => e.Seller != null)) {
    return CategoryGroupingType.seller;
  } else if (sales.any((e) => e.EnterpriseFantasyName != null)) {
    return CategoryGroupingType.enterprise;
  }

  return null;
}

PeriodGroupingType? _selectedPeriodGrouping(
  List<SaleStatisticViewModel> sales,
) {
  if (sales.any((e) => e.Hour != null)) {
    return PeriodGroupingType.hour;
  } else if (sales.any((e) => e.Date != null)) {
    return PeriodGroupingType.day;
  } else if (sales.any((e) => e.Month != null)) {
    return PeriodGroupingType.month;
  } else if (sales.any((e) => e.Year != null)) {
    return PeriodGroupingType.year;
  }
  return null;
}
