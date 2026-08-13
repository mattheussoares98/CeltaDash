import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class ReloadIconButton extends ConsumerStatefulWidget {
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  const ReloadIconButton({super.key, required this.refreshProvider});

  @override
  ConsumerState<ReloadIconButton> createState() => _ReloadIconButtonState();
}

class _ReloadIconButtonState extends ConsumerState<ReloadIconButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.refreshProvider != null) {
      final isLoading = ref.read(widget.refreshProvider!).isLoading;
      if (isLoading && !_animationController.isAnimating) {
        _animationController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refreshProvider == null) {
      return const SizedBox.shrink();
    }

    final provider = widget.refreshProvider!;
    final asyncState = ref.watch(provider);
    final isLoading = asyncState.isLoading;

    ref.listen<AsyncValue<dynamic>>(provider, (previous, next) {
      if (next.isLoading) {
        if (!_animationController.isAnimating) {
          _animationController.repeat();
        }
      } else if (previous?.isLoading == true) {
        _animationController.forward(from: _animationController.value).then((
          _,
        ) {
          if (mounted) {
            _animationController.reset();
          }
        });
      }
    });

    return IconButton(
      onPressed: isLoading ? null : () => ref.invalidate(provider),
      icon: SizedBox(
        width: 24,
        height: 24,
        child: RotationTransition(
          turns: _animationController,
          child: PlatformIcon(
            materialIcon: isLoading ? Icons.refresh : Icons.refresh_outlined,
            cupertinoIcon: isLoading
                ? CupertinoIcons.refresh
                : CupertinoIcons.refresh,
          ),
        ),
      ),
    );
  }
}
