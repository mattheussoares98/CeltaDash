import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/web_login/data/data.dart';
import 'package:celta_dash/features/web_login/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IWebLoginDatasource webLoginDatasource(Ref ref) =>
    WebLoginDatasource(ref.watch(firebaseAuthStorageProvider));

@riverpod
IWebLoginRepository webLoginRepository(Ref ref) =>
    WebLoginRepositoryImpl(ref.watch(webLoginDatasourceProvider));
