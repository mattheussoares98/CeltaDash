part of 'web_analytics_view.dart';

class _Filters extends StatelessWidget {
  const _Filters({
    required this.onPeriodChanged,
    required this.selectedPeriod,
    required this.filterController,
  });
  final void Function(DateTime) onPeriodChanged;
  final DateTime selectedPeriod;
  final TextEditingController filterController;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: BaseIconButton(
                  onPressed: () => onPeriodChanged(
                    DateTime(selectedPeriod.year, selectedPeriod.month - 1),
                  ),
                  platformIcon: const PlatformIcon(
                    materialIcon: Icons.chevron_left,
                    cupertinoIcon: CupertinoIcons.chevron_left,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  child: BaseText.titleLarge(selectedPeriod.formatDate(.yM)),
                ),
              ),
              Flexible(
                child: BaseIconButton(
                  onPressed:
                      selectedPeriod.year == now.year &&
                          selectedPeriod.month == now.month
                      ? null
                      : () => onPeriodChanged(
                          DateTime(
                            selectedPeriod.year,
                            selectedPeriod.month + 1,
                          ),
                        ),
                  platformIcon: const PlatformIcon(
                    materialIcon: Icons.chevron_right,
                    cupertinoIcon: CupertinoIcons.chevron_right,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: BaseTextFormField(
            labelText: 'Filtrar empresa'.hardcoded,
            hintText: 'Filtrar empresa'.hardcoded,
            controller: filterController,
            suffixIcon: BaseIconButton(
              onPressed: filterController.clear,
              platformIcon: const PlatformIcon(
                materialIcon: Icons.clear,
                cupertinoIcon: CupertinoIcons.clear,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
