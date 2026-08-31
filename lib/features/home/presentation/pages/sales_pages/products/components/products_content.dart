// lib/features/home/presentation/pages/products/components/products_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsContent extends HookConsumerWidget {
  const ProductsContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(ProductsPeriod.daily);
    final visitedPeriods = useState<Set<ProductsPeriod>>({
      ProductsPeriod.daily,
    });
    final filterController = useTextEditingController();
    useListenable(filterController);

    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(isPortrait ? Sizes.p8 : Sizes.p4),
          child: Row(
            children: [
              NewBaseSegmentedButtons<ProductsPeriod>(
                items: ProductsPeriod.values,
                selectedValue: selectedPeriod.value,
                onChanged: (value) {
                  selectedPeriod.value = value;
                  visitedPeriods.value.add(value);
                },
                itemLabelBuilder: (value) => value.label,
              ),
              gapW8,
              Expanded(
                child: SizedBox(
                  child: BaseTextFormField(
                    controller: filterController,
                    hintText: 'Filtrar produto'.hardcoded,
                    prefixIcon: const PlatformIcon(
                      materialIcon: Icons.search,
                      cupertinoIcon: CupertinoIcons.search,
                      size: 16,
                    ),
                    suffixIcon: filterController.text.isNotEmpty
                        ? BaseIconButton(
                            platformIcon: const PlatformIcon(
                              materialIcon: Icons.clear,
                              cupertinoIcon: CupertinoIcons.xmark,
                              size: 10,
                              color: Colors.red,
                            ),
                            onPressed: () => filterController.clear(),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        gapH8,
        Expanded(
          child: IndexedStack(
            index: selectedPeriod.value.index,
            children: [
              for (final period in ProductsPeriod.values)
                if (visitedPeriods.value.contains(period))
                  _ProductsPeriodView(
                    enterpriseId: enterpriseId,
                    period: period,
                    filterText: filterController.text,
                  )
                else
                  const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductsPeriodView extends ConsumerWidget {
  const _ProductsPeriodView({
    required this.enterpriseId,
    required this.period,
    required this.filterText,
  });

  final int enterpriseId;
  final ProductsPeriod period;
  final String filterText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = productsControllerProvider(enterpriseId, period);
    final statisticsAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: statisticsAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (statistics) {
        if (statistics.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                BaseText.error('Nenhuma venda encontrada'.hardcoded),
                Consumer(
                  builder: (_, ref, _) {
                    return PrimaryTextButton(
                      text: 'Carregar novamente'.hardcoded,
                      isLoading: ref.watch(provider.select((s) => s.isLoading)),
                      onPressed: () => ref.invalidate(provider),
                    );
                  },
                ),
              ],
            ),
          );
        }

        final filtered = filterText.trim().isEmpty
            ? statistics
            : statistics.where((s) {
                final query = filterText.trim().toLowerCase();
                final product = s.Product?.toLowerCase() ?? '';
                final parts = query.split(' ');
                return parts.every((p) => product.contains(p));
              }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: BaseText.error('Nenhum produto encontrado'.hardcoded),
          );
        }

        return ProductsTable(
          statistics: filtered,
          refreshProvider: provider,
          isLoading: statisticsAsync.isLoading,
        );
      },
    );
  }
}
