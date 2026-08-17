import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumePage extends HookConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      body: AsyncValueWidget(
        value: homeAsync,
        tryAgain: () => ref.invalidate(homeControllerProvider),
        data: (homeState) {
          final enterpriseId = homeState.selectedEnterpriseId;
          if (enterpriseId == null) return const DailyComparisonCard();

          final dailyProvider = dailyComparisonControllerProvider(enterpriseId);
          final monthlyProvider = monthlyGoalComparisonControllerProvider(
            enterpriseId,
          );
          final dailyAsync = ref.watch(dailyProvider);
          final monthlyAsync = ref.watch(monthlyProvider);
          final hasCompleteData =
              dailyAsync.value != null && monthlyAsync.value != null;

          if (!hasCompleteData) {
            return AsyncValueWidget(
              value: dailyAsync,
              tryAgain: () => ref.invalidate(dailyProvider),
              data: (_) => AsyncValueWidget(
                value: monthlyAsync,
                tryAgain: () => ref.invalidate(monthlyProvider),
                data: (_) => const SizedBox.shrink(),
              ),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              ref.invalidate(dailyProvider);
              ref.invalidate(monthlyProvider);
              try {
                await Future.wait([
                  ref.read(dailyProvider.future),
                  ref.read(monthlyProvider.future),
                ]);
              } catch (error) {
                showToastMessage(error.toString(), type: ToastType.error);
              }
            },
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(Sizes.p16),
              child: Column(
                children: [
                  DailyComparisonCard(),
                  gapH16,
                  MonthlyGoalComparisonCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
