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

String _$appStorageHash() => r'ea9d890b806af8f2fd7b666659aa1bbd188ef36e';

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

@ProviderFor(firebaseAuthStorage)
final firebaseAuthStorageProvider = FirebaseAuthStorageProvider._();

final class FirebaseAuthStorageProvider
    extends
        $FunctionalProvider<
          FirebaseAuthStorage,
          FirebaseAuthStorage,
          FirebaseAuthStorage
        >
    with $Provider<FirebaseAuthStorage> {
  FirebaseAuthStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthStorageHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuthStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAuthStorage create(Ref ref) {
    return firebaseAuthStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuthStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuthStorage>(value),
    );
  }
}

String _$firebaseAuthStorageHash() =>
    r'12e6edad2fe95a3272c33e7e5b2478446afdfc9e';

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

@ProviderFor(themeLocalDatasource)
final themeLocalDatasourceProvider = ThemeLocalDatasourceProvider._();

final class ThemeLocalDatasourceProvider
    extends
        $FunctionalProvider<
          IThemeLocalDatasource,
          IThemeLocalDatasource,
          IThemeLocalDatasource
        >
    with $Provider<IThemeLocalDatasource> {
  ThemeLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeLocalDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<IThemeLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IThemeLocalDatasource create(Ref ref) {
    return themeLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IThemeLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IThemeLocalDatasource>(value),
    );
  }
}

String _$themeLocalDatasourceHash() =>
    r'7ae3ec209967f1a1be393051d7f31d9a64b4d5b7';

@ProviderFor(themeRepository)
final themeRepositoryProvider = ThemeRepositoryProvider._();

final class ThemeRepositoryProvider
    extends
        $FunctionalProvider<
          IThemeRepository,
          IThemeRepository,
          IThemeRepository
        >
    with $Provider<IThemeRepository> {
  ThemeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeRepositoryHash();

  @$internal
  @override
  $ProviderElement<IThemeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IThemeRepository create(Ref ref) {
    return themeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IThemeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IThemeRepository>(value),
    );
  }
}

String _$themeRepositoryHash() => r'a648cb25ec979506e06a6cd0a7f66aa2041feaf6';

@ProviderFor(ecReleaseDatasource)
final ecReleaseDatasourceProvider = EcReleaseDatasourceProvider._();

final class EcReleaseDatasourceProvider
    extends
        $FunctionalProvider<
          IEcReleaseDatasource,
          IEcReleaseDatasource,
          IEcReleaseDatasource
        >
    with $Provider<IEcReleaseDatasource> {
  EcReleaseDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ecReleaseDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ecReleaseDatasourceHash();

  @$internal
  @override
  $ProviderElement<IEcReleaseDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IEcReleaseDatasource create(Ref ref) {
    return ecReleaseDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IEcReleaseDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IEcReleaseDatasource>(value),
    );
  }
}

String _$ecReleaseDatasourceHash() =>
    r'592a0630c088c75f1559b44197cca9c5a2d22fea';

@ProviderFor(ecReleaseRepository)
final ecReleaseRepositoryProvider = EcReleaseRepositoryProvider._();

final class EcReleaseRepositoryProvider
    extends
        $FunctionalProvider<
          IEcReleaseRepository,
          IEcReleaseRepository,
          IEcReleaseRepository
        >
    with $Provider<IEcReleaseRepository> {
  EcReleaseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ecReleaseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ecReleaseRepositoryHash();

  @$internal
  @override
  $ProviderElement<IEcReleaseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IEcReleaseRepository create(Ref ref) {
    return ecReleaseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IEcReleaseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IEcReleaseRepository>(value),
    );
  }
}

String _$ecReleaseRepositoryHash() =>
    r'62e2709a96dbf9b05fb9b815a1df99d4e974d3bd';
