import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReloadIconButton extends HookConsumerWidget {
  final List<ProviderBase<AsyncValue<dynamic>>>? refreshProviders;
  final VoidCallback? onRefresh;

  const ReloadIconButton({
    super.key,
    required this.refreshProviders,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if ((refreshProviders?.isEmpty ?? true) && onRefresh == null) {
      return const SizedBox.shrink();
    }

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );
    var isLoading = false;
    for (final provider
        in refreshProviders ?? <ProviderBase<AsyncValue<dynamic>>>[]) {
      if (ref.exists(provider)) {
        final providerIsLoading = ref.watch(
          provider.select((value) => value.isLoading),
        );
        isLoading = isLoading || providerIsLoading;
      }
    }

    useEffect(() {
      if (isLoading) {
        if (!animationController.isAnimating) {
          animationController.repeat();
        }
      } else {
        if (animationController.isAnimating) {
          animationController.forward(from: animationController.value).then((
            _,
          ) {
            animationController.reset();
          });
        }
      }
      return null;
    }, [isLoading]);

    void reload() {
      onRefresh?.call();
      if (refreshProviders?.isNotEmpty ?? false) {
        for (final provider in refreshProviders!) {
          if (ref.exists(provider)) {
            ref.invalidate(provider);
          }
        }
      }
    }

    return IconButton(
      onPressed: isLoading ? null : reload,
      icon: SizedBox(
        width: 24,
        height: 24,
        child: RotationTransition(
          turns: animationController,
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
