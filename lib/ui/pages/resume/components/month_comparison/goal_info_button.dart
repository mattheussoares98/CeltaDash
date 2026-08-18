import 'dart:math';

import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class GoalInfoButton extends StatelessWidget {
  final DateTime comparisonEndDate;
  final double comparisonLiquidValue;
  final double goalLiquidValue;
  const GoalInfoButton({
    super.key,
    required this.comparisonEndDate,
    required this.comparisonLiquidValue,
    required this.goalLiquidValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return InkWell(
      onTap: () {
        notificationDialog(
          context: context,
          titleMessage: R.string.goalInfo,
          showCancelAndConfirmMessage: false,
          showCloseAction: true,
          onPress: () async {},
          content: SizedBox(
            height: min(mediaQuery.size.height * 0.5, 400),
            child: Builder(
              builder: (context) {
                final formattedDate = DateFormat.yM("pt_BR").format(
                  DateTime(comparisonEndDate.year, comparisonEndDate.month),
                );
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _MonthlyInfo(
                        comparisonLiquidValue: comparisonLiquidValue,
                        goalLiquidValue: goalLiquidValue,
                        formattedDate: formattedDate,
                      ),
                      _DailyInfo(
                        goalLiquidValue: goalLiquidValue,
                        comparisonEndDate: comparisonEndDate,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Icon(
        theme.platform == TargetPlatform.iOS ? CupertinoIcons.info : Icons.info,
        color: theme.colorScheme.primary.withAlpha(200),
      ),
    );
  }
}

class _RowSpan extends StatelessWidget {
  final String title;
  final dynamic value;
  final bool showCoin;
  const _RowSpan({
    required this.title,
    required this.value,
    required this.showCoin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: title),
          if (showCoin)
            TextSpan(
              text: " R\$",
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
            ),
          TextSpan(
            text: value.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyInfo extends StatelessWidget {
  final double comparisonLiquidValue;
  final double goalLiquidValue;
  final String formattedDate;
  const _MonthlyInfo({
    required this.comparisonLiquidValue,
    required this.goalLiquidValue,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumePresenter = Get.find<ResumePresenter>();

    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            R.string.monthlyGoal.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          if (resumePresenter.firebaseEnterpriseGoal == null) ...[
            _RowSpan(
              title: "${R.string.goal} = ",
              value: "${R.string.salesFrom} ($formattedDate) + 5%",
              showCoin: false,
            ),
            _RowSpan(
              title: "${R.string.salesFrom} ($formattedDate) =",
              showCoin: true,
              value: comparisonLiquidValue.toString().toBRL(),
            ),
            _RowSpan(
              title: "5% = ",
              showCoin: true,
              value: (comparisonLiquidValue * 0.05)
                  .toString()
                  .toBRL(),
            ),
            _RowSpan(
              title: "${R.string.total} = ",
              showCoin: true,
              value: goalLiquidValue.toString().toBRL(),
            ),
          ] else ...[
            _RowSpan(
              title: "${R.string.manualInsertedGoal} = ",
              showCoin: true,
              value: goalLiquidValue.toString().toBRL(),
            ),
          ],
          if (resumePresenter.firebaseEnterpriseGoal?.userName != null)
            Text(
              "${R.string.changedBy}: ${resumePresenter.firebaseEnterpriseGoal!.userName!}",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}

class _DailyInfo extends StatelessWidget {
  final double goalLiquidValue;
  final DateTime comparisonEndDate;
  const _DailyInfo({
    required this.goalLiquidValue,
    required this.comparisonEndDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumePresenter = Get.find<ResumePresenter>();
    final homePresenter = Get.find<HomePresenter>();

    final endDate = resumePresenter.firebaseEnterpriseGoal?.value == null
        ? DateTime(comparisonEndDate.year, comparisonEndDate.month + 1, 0)
        : DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month + 1,
            0,
          );

    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            R.string.dailyGoal.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          _RowSpan(
            title: "${R.string.goal} = ",
            value:
                "${R.string.monthlyGoal} / ${(R.string.daysInMonth).toLowerCase()}",
            showCoin: false,
          ),
          _RowSpan(
            title: "${R.string.monthlyGoal} = ",
            value: goalLiquidValue.toString().toBRL(),
            showCoin: true,
          ),
          _RowSpan(
            title: "${R.string.daysInMonth} = ",
            value: endDate.day,
            showCoin: false,
          ),
          _RowSpan(
            title: "${R.string.total} = ",
            showCoin: true,
            value: (goalLiquidValue / endDate.day)
                .toString()
                .toBRL(),
          ),
        ],
      ),
    );
  }
}
