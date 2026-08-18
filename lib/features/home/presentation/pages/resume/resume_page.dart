import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumePage extends HookConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    final enterpriseId = ref.watch(
      homeControllerProvider.select((s) => s.value?.selectedEnterpriseId),
    );

    final providers = enterpriseId == null
        ? null
        : <ProviderBase<AsyncValue<dynamic>>>[
            dailyComparisonControllerProvider(enterpriseId),
            monthlyGoalComparisonControllerProvider(enterpriseId),
            monthlyAnalysisControllerProvider(enterpriseId),
            groupOfStoresControllerProvider(enterpriseId),
          ];

    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      onRefresh: () => ref.invalidate(resumeCurrentDateProvider),
      //TODO test this refresh indicator
      refreshProviders: providers,
      body: AsyncValueWidget(
        value: homeAsync,
        preserveValue: true,
        tryAgain: () => ref.invalidate(homeControllerProvider),
        data: (_) {
          if (enterpriseId == null) {
            return Center(
              child: BaseText.error('Nenhuma empresa selecionada'.hardcoded),
            );
          }

          final providerValues = [
            for (final provider in providers!)
              (provider: provider, value: ref.watch(provider)),
          ];
          final items = <Widget>[
            const DailyComparisonCard(),
            const MonthlyGoalComparisonCard(),
            const MonthlyAnalysisCard(),
            const GroupOfStoresCard(),
          ];
          Widget content = ResponsiveListFlow(
            maxItemWidth: Breakpoint.tablet,
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          );
          for (final providerValue in providerValues.reversed.where(
            (e) => e.value.hasError,
          )) {
            final child = content;
            content = AsyncValueWidget(
              value: providerValue.value,
              preserveValue: true,
              tryAgain: () => ref.invalidate(providerValue.provider),
              data: (_) => child,
            );
          }
          return content;
        },
      ),
    );
  }
}
