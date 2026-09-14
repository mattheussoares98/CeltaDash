import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/products/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementProductsContent extends HookConsumerWidget {
  const BuyMovementProductsContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(HomeBuyMovementPeriod.daily);
    final searchController = useTextEditingController();
    final provider = homeBuyMovementProductsControllerProvider(
      enterpriseId,
      selectedPeriod.value,
    );
    final rows = ref.watch(provider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            crossAxisAlignment: .center,
            alignment: .spaceEvenly,
            children: [
              NewBaseSegmentedButtons<HomeBuyMovementPeriod>(
                items: HomeBuyMovementPeriod.values
                    .where(
                      (e) =>
                          e != HomeBuyMovementPeriod.hourly &&
                          e != HomeBuyMovementPeriod.yearly,
                    )
                    .toList(),
                selectedValue: selectedPeriod.value,
                onChanged: (period) => selectedPeriod.value = period,
                itemLabelBuilder: (period) => period.label,
              ),
              SizedBox(
                width: 200,
                child: BaseTextFormField(
                  controller: searchController,
                  hintText: 'Buscar produto'.hardcoded,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: ref
                      .read(
                        homeBuyMovementProductsFilterControllerProvider
                            .notifier,
                      )
                      .setProductName,
                  prefixIcon: const PlatformIcon(
                    materialIcon: Icons.search,
                    cupertinoIcon: CupertinoIcons.search,
                  ),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : BaseIconButton(
                          onPressed: searchController.clear,
                          platformIcon: const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.delete,
                            materialIcon: Icons.delete,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AsyncValueWidget(
            value: rows,
            preserveValue: true,
            tryAgain: () => ref.invalidate(provider),
            data: (data) => data.isEmpty
                ? Center(child: BaseText('Nenhum produto encontrado'.hardcoded))
                : BuyMovementProductsTable(
                    rows: data,
                    refreshProvider: provider,
                    isLoading: rows.isLoading,
                  ),
          ),
        ),
      ],
    );
  }
}
