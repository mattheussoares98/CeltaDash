import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumeProvidersListener extends HookConsumerWidget {
  const ResumeProvidersListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final providerSubscriptions = <ProviderSubscription<dynamic>>[];

      void listenToResumeProviders(int? enterpriseId) {
        for (final subscription in providerSubscriptions) {
          subscription.close();
        }
        providerSubscriptions.clear();
        if (enterpriseId == null) return;

        providerSubscriptions.addAll([
          ref.listenManual(
            dailyComparisonControllerProvider(enterpriseId),
            (_, _) {},
          ),
          ref.listenManual(
            monthlyGoalComparisonControllerProvider(enterpriseId),
            (_, _) {},
          ),
          ref.listenManual(
            monthlyAnalysisControllerProvider(enterpriseId),
            (_, _) {},
          ),
          ref.listenManual(
            groupOfStoresControllerProvider(enterpriseId),
            (_, _) {},
          ),
        ]);
      }

      final enterpriseSubscription = ref.listenManual(
        homeControllerProvider.select(
          (state) => state.value?.selectedEnterpriseId,
        ),
        (_, n) {
          listenToResumeProviders(n);
        },
        fireImmediately: true,
      );

      return () {
        enterpriseSubscription.close();
        for (final subscription in providerSubscriptions) {
          subscription.close();
        }
      };
    }, [ref]);

    return const SizedBox.shrink();
  }
}
