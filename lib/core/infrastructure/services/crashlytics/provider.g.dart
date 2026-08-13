// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(crashlyticsService)
final crashlyticsServiceProvider = CrashlyticsServiceProvider._();

final class CrashlyticsServiceProvider
    extends
        $FunctionalProvider<
          ICrashlyticsService,
          ICrashlyticsService,
          ICrashlyticsService
        >
    with $Provider<ICrashlyticsService> {
  CrashlyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashlyticsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashlyticsServiceHash();

  @$internal
  @override
  $ProviderElement<ICrashlyticsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ICrashlyticsService create(Ref ref) {
    return crashlyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ICrashlyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ICrashlyticsService>(value),
    );
  }
}

String _$crashlyticsServiceHash() =>
    r'4d694be22361cf74216315ecfdff7ceaa76cfc12';
