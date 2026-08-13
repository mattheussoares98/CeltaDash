// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_numeric_focus_node_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveNumericFocusNode)
final activeNumericFocusNodeProvider = ActiveNumericFocusNodeProvider._();

final class ActiveNumericFocusNodeProvider
    extends $NotifierProvider<ActiveNumericFocusNode, FocusNode?> {
  ActiveNumericFocusNodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeNumericFocusNodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeNumericFocusNodeHash();

  @$internal
  @override
  ActiveNumericFocusNode create() => ActiveNumericFocusNode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FocusNode? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FocusNode?>(value),
    );
  }
}

String _$activeNumericFocusNodeHash() =>
    r'de0f7d0f8f5e0ec2986b27c75922e6939c27a1e9';

abstract class _$ActiveNumericFocusNode extends $Notifier<FocusNode?> {
  FocusNode? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FocusNode?, FocusNode?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FocusNode?, FocusNode?>,
              FocusNode?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
