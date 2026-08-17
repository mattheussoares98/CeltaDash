import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumePage extends HookConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    final enterpriseId = ref.watch(
      homeControllerProvider.select((s) => s.value?.selectedEnterpriseId),
    );

    final dailyProvider = enterpriseId == null
        ? null
        : dailyComparisonControllerProvider(enterpriseId);
    final monthlyProvider = enterpriseId == null
        ? null
        : monthlyGoalComparisonControllerProvider(enterpriseId);
    final monthlyAnalysisProvider = enterpriseId == null
        ? null
        : monthlyAnalysisControllerProvider(enterpriseId);

    if (dailyProvider != null) {
      ref.listen(dailyProvider, (p, n) {
        n.showToastOnError(context, p);
      });
    }
    if (monthlyProvider != null) {
      ref.listen(monthlyProvider, (p, n) {
        n.showToastOnError(context, p);
      });
    }
    if (monthlyAnalysisProvider != null) {
      ref.listen(monthlyAnalysisProvider, (p, n) {
        n.showToastOnError(context, p);
      });
    }
    //TODO throw an error for each controller to test

    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      //TODO test this refresh indicator
      refreshProviders: enterpriseId == null
          ? null
          : [
              //TODO it is not reloading the data when refreshing!
              dailyComparisonControllerProvider(enterpriseId),
              monthlyGoalComparisonControllerProvider(enterpriseId),
              monthlyAnalysisControllerProvider(enterpriseId),
            ],
      body: AsyncValueWidget(
        value: homeAsync,
        tryAgain: () => ref.invalidate(homeControllerProvider),
        data: (_) {
          if (enterpriseId == null) {
            return Center(
              child: BaseText.error('Nenhuma empresa selecionada'.hardcoded),
            );
          }

          final dailyAsync = ref.watch(dailyProvider!);
          final monthlyAsync = ref.watch(monthlyProvider!);
          final monthlyAnalysisAsync = ref.watch(monthlyAnalysisProvider!);

          final hasCompleteData =
              dailyAsync.value != null &&
              monthlyAsync.value != null &&
              monthlyAnalysisAsync.value != null;

          if (!hasCompleteData) {
            return AsyncValueWidget(
              value: dailyAsync,
              tryAgain: () => ref.invalidate(dailyProvider),
              data: (_) => AsyncValueWidget(
                value: monthlyAsync,
                tryAgain: () => ref.invalidate(monthlyProvider),
                data: (_) => AsyncValueWidget(
                  value: monthlyAnalysisAsync,
                  tryAgain: () => ref.invalidate(monthlyAnalysisProvider),
                  data: (_) => const SizedBox.shrink(),
                ),
              ),
            );
          }

          return const CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: DailyComparisonCard()),
              gapSliverH8,
              SliverToBoxAdapter(child: MonthlyGoalComparisonCard()),
              gapSliverH8,
              SliverToBoxAdapter(child: MonthlyAnalysisCard()),
            ],
          );
        },
      ),
    );
  }
}
