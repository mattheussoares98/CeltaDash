part of 'scrollable_table.dart';

/// Intentionally a private constant so it is never recreated.
const _kUnsortedIconColor = Color(0x78808080); // grey with alpha 120

class _ScrollableTableHeaderCell<T> extends StatelessWidget {
  final ScrollableTableColumnSpec<T> spec;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback? onTap;
  final VoidCallback? onPdfTap;

  const _ScrollableTableHeaderCell({
    required this.spec,
    required this.isSorted,
    required this.sortAscending,
    required this.onTap,
    this.onPdfTap,
  });

  @override
  Widget build(BuildContext context) {
    final canSort = spec.sortValueMapper != null;
    final sortIconColor = canSort && isSorted
        ? context.theme.primaryColor
        : _kUnsortedIconColor;
    final cupertinoSortIcon = sortAscending
        ? CupertinoIcons.arrow_up
        : CupertinoIcons.arrow_down;
    final materialSortIcon = sortAscending
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return SizedBox.expand(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSort ? onTap : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: onPdfTap != null ? 24.0 : 4.0,
                  ),
                  child: BaseRichText(
                    textAlign: TextAlign.center,
                    texts: [
                      BaseText.title(
                        spec.headerTitle,
                        textAlign: TextAlign.center,
                      ),
                      if (spec.isMoney == true)
                        BaseText.caption(' R\$', textAlign: TextAlign.center),
                      if (spec.isPercentage == true)
                        BaseText.caption(' %', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              if (onPdfTap != null)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onPdfTap,
                      borderRadius: BorderRadius.circular(Sizes.p4),
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p4),
                        child: PlatformIcon(
                          materialIcon: Icons.picture_as_pdf_outlined,
                          cupertinoIcon: CupertinoIcons.doc_text,
                          size: 18,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              if (canSort)
                Positioned(
                  bottom: Sizes.p4,
                  right: Sizes.p4,
                  child: PlatformIcon(
                    cupertinoIcon: isSorted
                        ? cupertinoSortIcon
                        : CupertinoIcons.arrow_up,
                    materialIcon: isSorted
                        ? materialSortIcon
                        : Icons.arrow_upward,
                    color: sortIconColor,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
