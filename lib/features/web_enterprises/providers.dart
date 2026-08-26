import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IWebEnterprisesDatasource webEnterprisesDatasource(Ref ref) =>
    WebEnterprisesDatasource(
      firebaseStorage: ref.watch(firebaseStorageProvider),
      soapRequest: ref.watch(soapRequestProvider),
      httpClient: ref.watch(httpClientProvider),
      localStorage: ref.watch(localStorageProvider),
    );

@riverpod
IWebEnterprisesRepository webEnterprisesRepository(Ref ref) =>
    WebEnterprisesRepositoryImpl(ref.watch(webEnterprisesDatasourceProvider));
