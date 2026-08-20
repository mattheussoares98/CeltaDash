import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SalesPagination extends StatelessWidget {
  const SalesPagination({
    required this.result,
    required this.isLoading,
    required this.onPageChanged,
    super.key,
  });

  final SaleMovementEntity result;
  final bool isLoading;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final firstRecord = (result.actualPage - 1) * result.recordsByPage + 1;
    final lastRecord = firstRecord + result.recordsOnThisPage - 1;
    final isFirstPage = result.actualPage <= 1;
    final isLastPage = result.actualPage >= result.totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Row(
        children: [
          BaseIconButton(
            onPressed: isFirstPage || isLoading
                ? null
                : () => onPageChanged(result.actualPage - 1),
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.arrow_left,
              materialIcon: Icons.arrow_back_ios_new_outlined,
            ),
          ),
          BaseText(
            'Página ${result.actualPage}/${result.totalPages}'.hardcoded,
          ),
          BaseIconButton(
            onPressed: isLastPage || isLoading
                ? null
                : () => onPageChanged(result.actualPage + 1),
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.arrow_right,
              materialIcon: Icons.arrow_forward_ios_outlined,
            ),
          ),
          const Spacer(),
          Column(
            children: [
              BaseText('Vendas'.hardcoded),
              BaseText('$firstRecord-$lastRecord/${result.totalRecords}'),
            ],
          ),
        ],
      ),
    );
  }
}
