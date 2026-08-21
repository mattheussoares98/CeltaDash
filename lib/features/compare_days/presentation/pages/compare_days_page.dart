import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/compare_days/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/compare_days/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompareDaysPage extends StatelessWidget {
  const CompareDaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          _CompareDaysContent(enterpriseId: enterpriseId),
    );
  }
}

class _CompareDaysContent extends ConsumerWidget {
  const _CompareDaysContent({required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = compareDaysControllerProvider(enterpriseId);
    final stateAsync = ref.watch(provider);
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return BaseScaffold(
      appBar: HomeAppBar(isLandscape: isLandscape),
      isScrollable: false,
      usePadding: false,
      body: Column(
        children: [
          CompareDaysDateSelector(enterpriseId: enterpriseId),
          AsyncValueWidget(
            value: stateAsync,
            preserveValue: true,
            tryAgain: () => ref.invalidate(provider),
            data: (state) {
              if (state.firstDayStatistics.isEmpty &&
                  state.secondDayStatistics.isEmpty) {
                return Center(
                  child: BaseText('Nenhuma venda encontrada'.hardcoded),
                );
              }

              return Expanded(
                child: CompareDaysTable(
                  state: state,
                  isLoading: stateAsync.isLoading,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
