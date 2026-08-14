import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// PERFORMANCE: Using an extension on WidgetRef allows for a clean,
/// functional approach in ConsumerWidgets without adding extra
/// boilerplate or converting to StatefulWidgets.
extension ObserveLoadingExtension on WidgetRef {
  /// Observes a list of [providers] and manages an Overlay loader.
  /// This is the most efficient way to handle side-effect UI in Riverpod.
  void observeLoading(List<ProviderListenable<AsyncValue<dynamic>>> providers) {
    // Listen to changes in the providers list
    for (final provider in providers) {
      listen(provider, (previous, next) {
        _handleOverlayState(providers);
      });
    }
  }

  void _handleOverlayState(
    List<ProviderListenable<AsyncValue<dynamic>>> providers,
  ) {
    bool isAnyLoading = false;
    for (final provider in providers) {
      // PERFORMANCE: Standard ref.read is used here to check the current
      // state without creating new reactive dependencies.
      if (read(provider).isLoading) {
        isAnyLoading = true;
        break;
      }
    }

    final overlayController = read(_loadingOverlayControllerProvider.notifier);
    if (isAnyLoading) {
      overlayController.show(context);
    } else {
      overlayController.hide();
    }
  }
}

/// PERFORMANCE: A singleton-style provider to manage the OverlayEntry.
/// This ensures only one loader exists in memory at any given time.
final _loadingOverlayControllerProvider =
    NotifierProvider<_LoadingOverlayController, void>(
      _LoadingOverlayController.new,
    );

class _LoadingOverlayController extends Notifier<void> {
  OverlayEntry? _entry;
  _LoadingPopEntry? _popEntry;
  ModalRoute<Object?>? _route;

  @override
  void build() {
    // Cleanup on provider destruction
    ref.onDispose(() => hide());
  }

  void show(BuildContext context) {
    if (_entry != null) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final route = ModalRoute.of(context);
    if (route != null) {
      _route = route;
      _popEntry = _LoadingPopEntry();
      _route!.registerPopEntry(_popEntry!);
    }

    final isIOS = PlatformUtil.isCupertino;

    _entry = OverlayEntry(
      builder: (context) {
        // PERFORMANCE: We use a PopScope to prevent the user from dismissing
        // the loading state with the back button, ensuring data integrity.
        return PopScope(
          canPop: false,
          child: Material(
            color: Colors.black54, // Provides the dim background (barrier)
            child: RepaintBoundary(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BaseText.titleMedium('Aguarde'.hardcoded),
                        const AnimatedEllipsis(),
                      ],
                    ),
                    gapH8,
                    isIOS
                        ? const LoadingWidget()
                        : const LinearProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  void hide() {
    if (_route != null && _popEntry != null) {
      if (_route!.isActive) {
        _route!.unregisterPopEntry(_popEntry!);
      }
      _popEntry!.dispose();
      _route = null;
      _popEntry = null;
    }
    _entry?.remove();
    _entry = null;
  }
}

class _LoadingPopEntry implements PopEntry<Object?> {
  @override
  final ValueNotifier<bool> canPopNotifier = ValueNotifier<bool>(false);

  void dispose() {
    canPopNotifier.dispose();
  }

  @override
  void onPopInvoked(bool didPop) {}

  @override
  void onPopInvokedWithResult(bool didPop, Object? result) {}
}
