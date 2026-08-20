part of 'scrollable_table.dart';

class _TappableRowIndicator extends StatelessWidget {
  const _TappableRowIndicator({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          bottom: 2,
          child: IgnorePointer(
            child: PlatformIcon(
              cupertinoIcon: Icons.touch_app,
              materialIcon: Icons.touch_app,
              size: Sizes.p16,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
