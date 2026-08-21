import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/enterprises_manager/data/data.dart';
import 'package:celta_dash/features/enterprises_manager/domain/domain.dart';
import 'package:celta_dash/features/login/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEnterprisesManagerDatasource enterprisesManagerDatasource(Ref ref) =>
    EnterprisesManagerDatasource(ref.watch(appStorageProvider));

@riverpod
IEnterprisesManagerRepository enterprisesManagerRepository(Ref ref) =>
    EnterprisesManagerRepositoryImpl(
      datasource: ref.watch(enterprisesManagerDatasourceProvider),
      loginRepository: ref.watch(loginRepositoryProvider),
    );
