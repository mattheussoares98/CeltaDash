import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SalesPaginationAndCancFilter extends StatelessWidget {
  const SalesPaginationAndCancFilter({
    required this.result,
    required this.isLoading,
    required this.onlyCancelled,
    required this.onOnlyCancelledChanged,
    required this.onPageChanged,
    super.key,
  });

  final SaleMovementEntity? result;
  final bool isLoading;
  final bool onlyCancelled;
  final ValueChanged<bool> onOnlyCancelledChanged;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final actualPage = result?.actualPage ?? 1;
    final firstRecord = ((actualPage - 1) * (result?.recordsByPage ?? 1)) + 1;
    final lastRecord = firstRecord + (result?.recordsOnThisPage ?? 0) - 1;
    final isFirstPage = actualPage <= 1;
    final isLastPage = actualPage >= (result?.totalPages ?? 1);

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              BaseIconButton(
                onPressed: isFirstPage || isLoading
                    ? null
                    : () => onPageChanged(actualPage - 1),
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.arrow_left,
                  materialIcon: Icons.arrow_back_ios_new_outlined,
                  size: 12,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    BaseText(
                      'Página $actualPage/${result?.totalPages ?? 0}'.hardcoded,
                      textAlign: .center,
                    ),
                    BaseText.caption(
                      '$firstRecord-$lastRecord/${result?.totalRecords ?? 0}',
                      textAlign: .center,
                    ),
                  ],
                ),
              ),
              BaseIconButton(
                onPressed: isLastPage || isLoading
                    ? null
                    : () => onPageChanged(actualPage + 1),
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.arrow_right,
                  materialIcon: Icons.arrow_forward_ios_outlined,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: BaseSwitch(
            title: BaseText.title('Somente canceladas'.hardcoded),
            value: onlyCancelled,
            onChanged: isLoading ? null : onOnlyCancelledChanged,
          ),
        ),
      ],
    );
  }
}
