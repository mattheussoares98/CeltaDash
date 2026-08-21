import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/compare_months/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/compare_months/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompareMonthsPage extends StatelessWidget {
  const CompareMonthsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          _CompareMonthsContent(enterpriseId: enterpriseId),
    );
  }
}

class _CompareMonthsContent extends ConsumerWidget {
  const _CompareMonthsContent({required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = compareMonthsControllerProvider(enterpriseId);
    final stateAsync = ref.watch(provider);

    return BaseScaffold(
      appBar: HomeAppBar(
        isLandscape: false,
        showSelectDate: false,
        leading: BaseIconButton(
          onPressed: context.pop,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.back,
            materialIcon: Icons.arrow_back,
          ),
        ),
      ),
      isScrollable: false,
      usePadding: false,
      body: Column(
        children: [
          CompareMonthsDateSelector(enterpriseId: enterpriseId),
          AsyncValueWidget(
            value: stateAsync,
            preserveValue: true,
            tryAgain: () => ref.invalidate(provider),
            data: (state) {
              if (state.firstMonthStatistics.isEmpty &&
                  state.secondMonthStatistics.isEmpty) {
                return Center(
                  child: BaseText('Nenhuma venda encontrada'.hardcoded),
                );
              }

              return Expanded(
                child: CompareMonthsTable(
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
