part of 'scrollable_table.dart';

class _ScrollableHandAnimation extends StatelessWidget {
  final Listenable animation;
  final Animation<double> handPositionAnimation;
  final Animation<double> handOpacityAnimation;
  final double available;
  final double headerHeight;
  final double rowHeight;

  const _ScrollableHandAnimation({
    required this.animation,
    required this.handPositionAnimation,
    required this.handOpacityAnimation,
    required this.available,
    required this.headerHeight,
    required this.rowHeight,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: animation,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: PlatformIcon(
          cupertinoIcon: CupertinoIcons.hand_point_right,
          materialIcon: Icons.touch_app,
          size: 32,
          color: primaryColor,
        ),
      ),
      builder: (context, child) {
        return Positioned(
          left: available * handPositionAnimation.value - 24,
          top: (headerHeight + rowHeight) / 2 + 10,
          child: IgnorePointer(
            child: Opacity(opacity: handOpacityAnimation.value, child: child),
          ),
        );
      },
    );
  }
}
