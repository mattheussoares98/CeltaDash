import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'filters.dart';

class WebAnalyticsView extends HookConsumerWidget {
  const WebAnalyticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final selectedPeriod = useState(DateTime(now.year, now.month));

    void onPeriodChanged(DateTime period) {
      selectedPeriod.value = period;
    }

    final filterController = useTextEditingController();

    return Column(
      children: [
        _Filters(
          onPeriodChanged: onPeriodChanged,
          selectedPeriod: selectedPeriod.value,
          filterController: filterController,
        ),
        gapH8,
        AnimatedBuilder(
          animation: filterController,
          builder: (context, _) {
            return AsyncValueWidget(
              value: ref.watch(
                webAnalyticsControllerProvider(selectedPeriod.value),
              ),
              preserveValue: true,
              tryAgain: () => ref.invalidate(
                webAnalyticsControllerProvider(selectedPeriod.value),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: BaseText.error(
                      'Nenhuma análise encontrada'.hardcoded,
                    ),
                  );
                }

                final filteredItems = items.where((e) {
                  return e.enterprise.trim().toLowerCase().contains(
                    filterController.text.trim().toLowerCase(),
                  );
                }).toList();

                int sum(List<WebAnalyticsSearchCountEntity> items) {
                  return items.fold(0, (total, item) => total + item.count);
                }

                filteredItems.sort(
                  (a, b) => sum(b.searchCounts).compareTo(sum(a.searchCounts)),
                );

                return Expanded(
                  child: ResponsiveListFlow(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final analytic = filteredItems[index];
                      final totalRequests = analytic.searchCounts.fold<int>(
                        0,
                        (total, item) => total + item.count,
                      );

                      analytic.searchCounts.sort(
                        (a, b) => b.count.compareTo(a.count),
                      );
                      return ExpansionTile(
                        title: Row(
                          children: [
                            const PlatformIcon(
                              materialIcon: Icons.auto_graph,
                              cupertinoIcon: Icons.auto_graph,
                            ),
                            gapW8,
                            Expanded(child: BaseText(analytic.enterprise)),
                          ],
                        ),
                        subtitle: BaseText(
                          '${analytic.users.length} ${'usuários'.hardcoded} · '
                          '$totalRequests ${'consultas'.hardcoded}',
                        ),
                        children: [
                          ...analytic.searchCounts.map((searchCount) {
                            return Row(
                              children: [
                                Expanded(
                                  child: BaseText(
                                    '${searchCount.reportType.label} (${searchCount.periodType.label})',
                                  ),
                                ),
                                gapW4,
                                BaseText(
                                  '${searchCount.count} ${'consultas'.hardcoded}',
                                ),
                              ],
                            );
                          }),
                          const Divider(),
                          RichText(
                            text: TextSpan(
                              style: context.textTheme.bodyMedium,
                              children: [
                                for (var user in analytic.users) ...[
                                  TextSpan(text: user.userName),
                                  WidgetSpan(
                                    alignment: .middle,
                                    child: Icon(
                                      user.platform == 'ios'
                                          ? Icons.apple
                                          : Icons.android,
                                    ),
                                  ),
                                  const TextSpan(text: ' '),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
