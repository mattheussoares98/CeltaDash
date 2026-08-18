import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class QuantityBadge extends StatefulWidget {
  final int? quantity;
  final PlatformIcon platformIcon;
  final bool isSelected;
  final double? totalPrice;
  final bool animateInfinite;
  const QuantityBadge({
    super.key,
    required this.quantity,
    required this.platformIcon,
    required this.isSelected,
    this.totalPrice,
    this.animateInfinite = false,
  });

  @override
  State<QuantityBadge> createState() => _QuantityBadgeState();
}

class _QuantityBadgeState extends State<QuantityBadge>
    with TickerProviderStateMixin {
  late AnimationController _quantityController;
  late Animation<double> _quantityScaleAnimation;
  late Animation<double> _quantityRollingAnimation;

  late AnimationController _priceController;
  late Animation<double> _priceRollingAnimation;

  late AnimationController _infiniteController;
  late Animation<double> _infiniteScaleAnimation;

  @override
  void initState() {
    super.initState();
    _quantityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _quantityScaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _quantityController, curve: Curves.easeInOut),
        );

    _quantityRollingAnimation = AlwaysStoppedAnimation(
      (widget.quantity ?? 0).toDouble(),
    );

    _priceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _priceRollingAnimation = AlwaysStoppedAnimation(widget.totalPrice ?? 0.0);

    _infiniteController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _infiniteScaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1, end: 1.5), weight: 100),
          TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 100),
        ]).animate(
          CurvedAnimation(parent: _infiniteController, curve: Curves.easeInOut),
        );

    if (widget.animateInfinite && (widget.quantity ?? 0) > 0) {
      _infiniteController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant QuantityBadge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.quantity != widget.quantity) {
      _quantityRollingAnimation =
          Tween<double>(
            begin: (oldWidget.quantity ?? 0).toDouble(),
            end: (widget.quantity ?? 0).toDouble(),
          ).animate(
            CurvedAnimation(parent: _quantityController, curve: Curves.easeOut),
          );
      _quantityController.forward(from: 0.0);
    }

    if (oldWidget.totalPrice != widget.totalPrice &&
        widget.totalPrice != null) {
      _priceRollingAnimation =
          Tween<double>(
            begin: oldWidget.totalPrice ?? 0.0,
            end: widget.totalPrice ?? 0.0,
          ).animate(
            CurvedAnimation(parent: _priceController, curve: Curves.easeOut),
          );
      _priceController.forward(from: 0.0);
    }

    final shouldAnimate = widget.animateInfinite && (widget.quantity ?? 0) > 0;
    final wasAnimating =
        oldWidget.animateInfinite && (oldWidget.quantity ?? 0) > 0;

    if (shouldAnimate && !wasAnimating) {
      _infiniteController.repeat();
    } else if (!shouldAnimate && wasAnimating) {
      _infiniteController.stop();
      _infiniteController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _infiniteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = (widget.quantity?.toString() ?? '0').length <= 1;

    //! if it is on AppBar actions, should put this padding below
    //*actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
    return RepaintBoundary(
      child: Badge(
        padding: const EdgeInsets.all(Sizes.p4),
        backgroundColor: Colors.transparent,
        label: ScaleTransition(
          scale: (widget.animateInfinite && (widget.quantity ?? 0) > 0)
              ? _infiniteScaleAnimation
              : _quantityScaleAnimation,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            radius: isSmall ? 8 : 10,
            child: Padding(
              padding: EdgeInsets.all(isSmall ? 1 : 2),
              child: Center(
                child: FittedBox(
                  child: AnimatedBuilder(
                    animation: _quantityRollingAnimation,
                    builder: (context, child) {
                      return BaseText(
                        _quantityRollingAnimation.value.round().toString(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PlatformIcon(
              cupertinoIcon: widget.platformIcon.cupertinoIcon,
              materialIcon: widget.platformIcon.materialIcon,
              color: widget.isSelected
                  ? context.theme.primaryColor
                  : context.theme.disabledColor,
            ),
            if (widget.totalPrice != null)
              AnimatedBuilder(
                animation: _priceRollingAnimation,
                builder: (context, child) {
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'R\$ ',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            fontSize: 9,
                          ),
                        ),
                        TextSpan(
                          text: _priceRollingAnimation.value
                              .toString()
                              .toBRL(),
                          style: context.theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
