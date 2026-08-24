import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class WebAnalyticsView extends ConsumerWidget {
  final DateTime selectedPeriod;
  final ValueChanged<DateTime> onPeriodChanged;

  const WebAnalyticsView({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(webAnalyticsControllerProvider(selectedPeriod));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Mês anterior'.hardcoded,
              onPressed: () => onPeriodChanged(
                DateTime(selectedPeriod.year, selectedPeriod.month - 1),
              ),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              DateFormat('MM/yyyy').format(selectedPeriod),
              style: context.theme.textTheme.titleLarge,
            ),
            IconButton(
              tooltip: 'Próximo mês'.hardcoded,
              onPressed: () => onPeriodChanged(
                DateTime(selectedPeriod.year, selectedPeriod.month + 1),
              ),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        gapH8,
        Expanded(
          child: AsyncValueWidget(
            value: analytics,
            preserveValue: true,
            tryAgain: () =>
                ref.invalidate(webAnalyticsControllerProvider(selectedPeriod)),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text('Nenhuma análise encontrada'.hardcoded),
                );
              }

              return RefreshIndicator.adaptive(
                onRefresh: () => ref
                    .read(
                      webAnalyticsControllerProvider(selectedPeriod).notifier,
                    )
                    .refresh(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => gapH8,
                  itemBuilder: (context, index) {
                    final analytic = items[index];
                    final totalRequests = analytic.searchCounts.fold<int>(
                      0,
                      (total, item) => total + item.count,
                    );
                    return Card(
                      child: ListTile(
                        leading: const PlatformIcon(
                          materialIcon: Icons.auto_graph,
                          cupertinoIcon: Icons.auto_graph,
                        ),
                        title: Text(analytic.enterprise),
                        subtitle: Text(
                          '${analytic.users.length} ${'usuários'.hardcoded} · '
                          '$totalRequests ${'consultas'.hardcoded}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
