import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IWebEnterprisesDatasource webEnterprisesDatasource(Ref ref) =>
    WebEnterprisesDatasource(ref.watch(firebaseStorageProvider));

@riverpod
IWebEnterprisesRepository webEnterprisesRepository(Ref ref) =>
    WebEnterprisesRepositoryImpl(ref.watch(webEnterprisesDatasourceProvider));
