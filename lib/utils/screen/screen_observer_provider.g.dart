// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_observer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScreenObserver)
final screenObserverProvider = ScreenObserverProvider._();

final class ScreenObserverProvider
    extends $NotifierProvider<ScreenObserver, ScreenObserverState> {
  ScreenObserverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenObserverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenObserverHash();

  @$internal
  @override
  ScreenObserver create() => ScreenObserver();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenObserverState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenObserverState>(value),
    );
  }
}

String _$screenObserverHash() => r'3ab3445e6bdfe91217b029edae35c89457eeba88';

abstract class _$ScreenObserver extends $Notifier<ScreenObserverState> {
  ScreenObserverState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScreenObserverState, ScreenObserverState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScreenObserverState, ScreenObserverState>,
              ScreenObserverState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
