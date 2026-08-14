// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rawHttpClient)
final rawHttpClientProvider = RawHttpClientProvider._();

final class RawHttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  RawHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawHttpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawHttpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return rawHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$rawHttpClientHash() => r'0afa6c6dfcb0a8f470c3d707f8345ff43d63061a';

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<HttpClient, HttpClient, HttpClient>
    with $Provider<HttpClient> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<HttpClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HttpClient create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpClient>(value),
    );
  }
}

String _$httpClientHash() => r'e330b95dbb965f86e1c9780c27509b9613b2d74b';

@ProviderFor(hiveStorage)
final hiveStorageProvider = HiveStorageProvider._();

final class HiveStorageProvider
    extends $FunctionalProvider<HiveStorage, HiveStorage, HiveStorage>
    with $Provider<HiveStorage> {
  HiveStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveStorageHash();

  @$internal
  @override
  $ProviderElement<HiveStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HiveStorage create(Ref ref) {
    return hiveStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveStorage>(value),
    );
  }
}

String _$hiveStorageHash() => r'1d526ed93cc7aa93f75aa7c5c73d0e9b0489809f';

@ProviderFor(localStorage)
final localStorageProvider = LocalStorageProvider._();

final class LocalStorageProvider
    extends $FunctionalProvider<LocalStorage, LocalStorage, LocalStorage>
    with $Provider<LocalStorage> {
  LocalStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageHash();

  @$internal
  @override
  $ProviderElement<LocalStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalStorage create(Ref ref) {
    return localStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorage>(value),
    );
  }
}

String _$localStorageHash() => r'fc597f102c8b93474eee57132131815532c0fb80';

@ProviderFor(appStorage)
final appStorageProvider = AppStorageProvider._();

final class AppStorageProvider
    extends $FunctionalProvider<IAppStorage, IAppStorage, IAppStorage>
    with $Provider<IAppStorage> {
  AppStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStorageHash();

  @$internal
  @override
  $ProviderElement<IAppStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAppStorage create(Ref ref) {
    return appStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAppStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAppStorage>(value),
    );
  }
}

String _$appStorageHash() => r'e62e2e05ab70f8d21aa61ca14c615f11e8dad15f';

@ProviderFor(soapRequest)
final soapRequestProvider = SoapRequestProvider._();

final class SoapRequestProvider
    extends $FunctionalProvider<SoapRequest, SoapRequest, SoapRequest>
    with $Provider<SoapRequest> {
  SoapRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soapRequestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soapRequestHash();

  @$internal
  @override
  $ProviderElement<SoapRequest> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoapRequest create(Ref ref) {
    return soapRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoapRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoapRequest>(value),
    );
  }
}

String _$soapRequestHash() => r'5aa18294290a28d3b75f4b534b7b54632882c1aa';

@ProviderFor(firebaseStorage)
final firebaseStorageProvider = FirebaseStorageProvider._();

final class FirebaseStorageProvider
    extends
        $FunctionalProvider<FirebaseStorage, FirebaseStorage, FirebaseStorage>
    with $Provider<FirebaseStorage> {
  FirebaseStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseStorageHash();

  @$internal
  @override
  $ProviderElement<FirebaseStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseStorage create(Ref ref) {
    return firebaseStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseStorage>(value),
    );
  }
}

String _$firebaseStorageHash() => r'fe4dc94c54a2d6d86214c255db3f611075a9f85d';

@ProviderFor(firebaseManager)
final firebaseManagerProvider = FirebaseManagerProvider._();

final class FirebaseManagerProvider
    extends
        $FunctionalProvider<FirebaseManager, FirebaseManager, FirebaseManager>
    with $Provider<FirebaseManager> {
  FirebaseManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseManagerHash();

  @$internal
  @override
  $ProviderElement<FirebaseManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseManager create(Ref ref) {
    return firebaseManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseManager>(value),
    );
  }
}

String _$firebaseManagerHash() => r'62ac1ae04bccadb63f56bce3d54ed3ecc1aef6b7';

@ProviderFor(deviceService)
final deviceServiceProvider = DeviceServiceProvider._();

final class DeviceServiceProvider
    extends $FunctionalProvider<IDeviceService, IDeviceService, IDeviceService>
    with $Provider<IDeviceService> {
  DeviceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceServiceHash();

  @$internal
  @override
  $ProviderElement<IDeviceService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IDeviceService create(Ref ref) {
    return deviceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IDeviceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IDeviceService>(value),
    );
  }
}

String _$deviceServiceHash() => r'9a1a1f9b92bb9c30e9ec72ef142a3b022f29c317';
