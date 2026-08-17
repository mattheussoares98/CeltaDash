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

    void showError(AsyncValue? p, AsyncValue n) {
      if (p?.hasValue ?? false) {
        n.showToastOnError(context, p);
      }
    }

    for (final provider in providers ?? const []) {
      ref.listen(provider, showError);
    }
    //TODO throw an error for each controller to test

    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      onRefresh: () => ref.invalidate(resumeCurrentDateProvider),
      //TODO test this refresh indicator
      refreshProviders: providers,
      body: AsyncValueWidget(
        value: homeAsync,
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
          final hasCompleteData = providerValues.every(
            (e) => e.value.value != null,
          );
          final failedProviders = providerValues
              .where((e) => e.value.hasError)
              .toList();

          if (!hasCompleteData) {
            final firstIncompleteProvider = providerValues.firstWhere(
              (e) => e.value.value == null,
            );

            return AsyncValueWidget(
              value: firstIncompleteProvider.value,
              tryAgain: () {
                for (final failedProvider in failedProviders) {
                  ref.invalidate(failedProvider.provider);
                }
              },
              data: (_) => const SizedBox.shrink(),
            );
          }

          final items = <Widget>[
            const DailyComparisonCard(),
            const MonthlyGoalComparisonCard(),
            const MonthlyAnalysisCard(),
            const GroupOfStoresCard(),
          ];
          return ResponsiveListFlow(
            maxItemWidth: Breakpoint.tablet,
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          );
        },
      ),
    );
  }
}
