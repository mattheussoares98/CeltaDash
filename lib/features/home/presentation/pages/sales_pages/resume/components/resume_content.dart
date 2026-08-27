import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumeContent extends HookConsumerWidget {
  const ResumeContent({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyGoalsProvider = monthlyGoalsControllerProvider;
    final providers = <ProviderBase<AsyncValue<dynamic>>>[
      dailyComparisonControllerProvider(enterpriseId),
      monthlyGoalComparisonControllerProvider(enterpriseId),
      monthlyAnalysisControllerProvider(enterpriseId),
      groupOfStoresControllerProvider(enterpriseId),
    ];

    final providerValues = [
      for (final provider in providers)
        (provider: provider, value: ref.watch(provider)),
    ];
    final items = <Widget>[
      DailyComparisonCard(enterpriseId: enterpriseId),
      MonthlyGoalComparisonCard(enterpriseId: enterpriseId),
      MonthlyAnalysisCard(enterpriseId: enterpriseId),
      GroupOfStoresCard(enterpriseId: enterpriseId),
    ];
    final errors = providerValues
        .where((item) => item.value.hasError && !item.value.hasValue)
        .toList();
    final isInitialLoading = providerValues.any(
      (item) => item.value.isLoading && !item.value.hasValue,
    );

    Widget content;
    if (isInitialLoading) {
      content = const LoadingCircle();
    } else if (errors.isNotEmpty) {
      content = ListView(
        children: [
          for (final item in errors)
            AsyncValueWidget(
              value: item.value,
              preserveValue: true,
              tryAgain: null,
              data: (_) => const SizedBox.shrink(),
            ),
          gapH16,
          Center(
            child: PrimaryTextButton(
              text: 'Tentar novamente'.hardcoded,
              onPressed: () {
                ref.invalidate(monthlyGoalsProvider);
                for (final item in errors) {
                  ref.invalidate(item.provider);
                }
              },
              platformIcon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.refresh,
                materialIcon: Icons.refresh,
              ),
            ),
          ),
        ],
      );
    } else {
      content = ResponsiveListFlow(
        maxItemWidth: Breakpoint.tablet,
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      );
    }

    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      onRefresh: () => ref.invalidate(resumeCurrentDateProvider),
      refreshProviders: [monthlyGoalsProvider, ...providers],
      body: content,
    );
  }
}
