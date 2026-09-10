import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/resume/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementResumeContent extends HookConsumerWidget {
  const BuyMovementResumeContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = <ProviderBase<AsyncValue<dynamic>>>[
      homeBuyMovementControllerProvider(
        enterpriseId,
        HomeBuyMovementPeriod.hourly,
      ),
      homeBuyMovementControllerProvider(
        enterpriseId,
        HomeBuyMovementPeriod.daily,
      ),
      buyMovementGroupOfStoresControllerProvider(enterpriseId),
      homeBuyMovementProductsControllerProvider(
        enterpriseId,
        HomeBuyMovementPeriod.hourly,
      ),
    ];
    final providerValues = [
      for (final provider in providers)
        (provider: provider, value: ref.watch(provider)),
    ];
    final values = providerValues.map((item) => item.value).toList();
    if (values.any((value) => value.isLoading && !value.hasValue)) {
      return const LoadingCircle();
    }
    final errors = providerValues.where((item) => item.value.hasError).toList();
    if (errors.isNotEmpty) {
      return BuyMovementResumeErrors(errors: errors);
    }

    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      refreshProviders: providers,
      body: Column(
        children: [
          if (values.any((value) => value.isLoading))
            const LinearProgressIndicator(),
          Expanded(
            child: ResponsiveListFlow(
              maxItemWidth: Breakpoint.tablet,
              itemCount: 4,
              itemBuilder: (context, index) => [
                BuyMovementPeriodChartCard(
                  enterpriseId: enterpriseId,
                  period: HomeBuyMovementPeriod.hourly,
                  title: 'Compras do dia'.hardcoded,
                ),
                BuyMovementPeriodChartCard(
                  enterpriseId: enterpriseId,
                  period: HomeBuyMovementPeriod.daily,
                  title: 'Compras do mês'.hardcoded,
                ),
                BuyMovementGroupOfStoresCard(enterpriseId: enterpriseId),
                BuyMovementTopProductsCard(enterpriseId: enterpriseId),
              ][index],
            ),
          ),
        ],
      ),
    );
  }
}
