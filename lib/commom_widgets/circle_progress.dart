import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedCircleProgress extends HookWidget {
  final double value;
  final double maximum;
  final double height;
  final double width;
  final String? title;
  const AnimatedCircleProgress({
    super.key,
    required this.value,
    required this.maximum,
    required this.height,
    required this.width,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 1),
    );
    final progressAnimation = useMemoized(
      () => Tween<double>(
        begin: 0,
        end: value / maximum,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      [controller, value, maximum],
    );
    final widgetKey = useMemoized(GlobalKey.new);
    final hasAnimated = useRef(false);

    useEffect(() {
      void checkVisibility() {
        final renderBox =
            widgetKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null) return;

        final position = renderBox.localToGlobal(Offset.zero);
        final isVisible =
            position.dy < MediaQuery.sizeOf(context).height &&
            position.dy + renderBox.size.height > 0;

        if (isVisible && !hasAnimated.value) {
          controller.forward(from: 0);
          hasAnimated.value = true;
        } else if (!isVisible) {
          hasAnimated.value = false;
        }
      }

      final scrollPosition = Scrollable.maybeOf(context)?.position;
      scrollPosition?.addListener(checkVisibility);
      WidgetsBinding.instance.addPostFrameCallback((_) => checkVisibility());
      return () => scrollPosition?.removeListener(checkVisibility);
    }, [controller]);

    return Column(
      children: [
        if (title != null)
          Column(
            children: [
              BaseText.title(title!),
              BaseRichText(
                texts: [
                  BaseText.caption('R\$ '),
                  BaseText.bodySmall(maximum.toString().toBRL()),
                ],
              ),
              gapH8,
            ],
          ),
        GestureDetector(
          onTap: () {
            controller.forward(from: 0);
            hasAnimated.value = true;
          },
          child: SizedBox(
            width: width,
            height: height,
            key: widgetKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedBuilder(
                  animation: progressAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: _ProgressCirclePainter(
                            progress: progressAnimation.value,
                            backgroundColor: IsDarkTheme.isDark
                                ? context.theme.disabledColor
                                : context.theme.disabledColor.withAlpha(20),
                            progressColor: value >= maximum
                                ? context.theme.primaryColor
                                : Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: BaseRichText(
                                  color: value >= maximum
                                      ? context.theme.primaryColor
                                      : Colors.red,
                                  texts: [
                                    BaseText.caption('R\$ '),
                                    BaseText.title(
                                      value.toString().toBRL(),
                                    ),
                                  ],
                                ),
                              ),
                              if (value > 0 && maximum > 0)
                                FittedBox(
                                  child: BaseText(
                                    "${(value / maximum * 100).toString().toBRL()}%",
                                    color: value >= maximum
                                        ? context.theme.primaryColor
                                        : Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressCirclePainter({
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.green,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 5) / 2;

    // fundo
    canvas.drawCircle(center, radius, backgroundPaint);

    // arco do progresso
    final double sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
