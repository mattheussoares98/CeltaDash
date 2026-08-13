// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_visibility_state_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KeyboardVisibilityStateController)
final keyboardVisibilityStateControllerProvider =
    KeyboardVisibilityStateControllerProvider._();

final class KeyboardVisibilityStateControllerProvider
    extends $NotifierProvider<KeyboardVisibilityStateController, bool> {
  KeyboardVisibilityStateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardVisibilityStateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$keyboardVisibilityStateControllerHash();

  @$internal
  @override
  KeyboardVisibilityStateController create() =>
      KeyboardVisibilityStateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$keyboardVisibilityStateControllerHash() =>
    r'f25b7e75a97d357d90a444695a3d8df4db9824a7';

abstract class _$KeyboardVisibilityStateController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
