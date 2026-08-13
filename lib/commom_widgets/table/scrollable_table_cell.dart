part of 'scrollable_table.dart';

class _ScrollableTableCell extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final Color? backgroundColor;
  final bool? showTopBorder;
  final bool? showBottomBorder;
  final ScrollableTableColumnSpec<dynamic> spec;

  const _ScrollableTableCell({
    required this.child,
    required this.width,
    required this.height,
    required this.spec,
    this.backgroundColor,
    this.showTopBorder,
    this.showBottomBorder,
  });

  @override
  Widget build(BuildContext context) {
    if (child == null) return const SizedBox.shrink();

    Widget processedChild = child!;

    if (processedChild is BaseText) {
      final baseText = processedChild;
      processedChild = BaseRichText(
        texts: [
          if (spec.isMoney == true)
            BaseText.caption(
              'R\$ ',
              color: baseText.color,
              fontWeight: baseText.fontWeight,
            ),
          processedChild,
          if (spec.isPercentage == true)
            BaseText.caption(
              ' %',
              color: baseText.color,
              fontWeight: baseText.fontWeight,
            ),
        ],
      );
    }

    final dividerColor = context.theme.dividerColor;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: showTopBorder == true
              ? BorderSide(color: dividerColor, width: 0.5)
              : BorderSide.none,
          bottom: showBottomBorder == true
              ? BorderSide(color: dividerColor, width: 0.5)
              : BorderSide.none,
          right: BorderSide(color: dividerColor, width: 0.07),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: processedChild,
    );
  }
}
