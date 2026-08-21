import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/enterprises_manager/data/datasource/datasource.dart';
import 'package:celta_dash/features/enterprises_manager/domain/domain.dart';
import 'package:celta_dash/features/login/domain/domain.dart';
import 'package:celta_dash/utils/utils.dart';

class EnterprisesManagerRepositoryImpl
    implements IEnterprisesManagerRepository {
  const EnterprisesManagerRepositoryImpl({
    required IEnterprisesManagerDatasource datasource,
    required ILoginRepository loginRepository,
  }) : _datasource = datasource,
       _loginRepository = loginRepository;

  final IEnterprisesManagerDatasource _datasource;
  final ILoginRepository _loginRepository;

  @override
  Future<List<FirebaseEnterpriseEntity>> loadEnterprises() async {
    final models = await _datasource.loadEnterprises();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<FirebaseEnterpriseEntity?> loadSelectedEnterprise() async {
    final model = await _datasource.loadSelectedEnterprise();
    return model?.toEntity();
  }

  @override
  Future<FirebaseEnterpriseEntity> addEnterprise(
    AddEnterpriseParams params,
  ) async {
    final savedEnterprises = await _datasource.loadEnterprises();
    final normalizedName = _normalize(params.enterpriseName);
    final alreadyExists = savedEnterprises.any(
      (enterprise) => _normalize(enterprise.enterpriseName) == normalizedName,
    );
    if (alreadyExists) {
      throw AppException('Esta empresa já foi adicionada'.hardcoded);
    }

    final enterprise = await _loginRepository.login(
      LoginParams(
        enterpriseName: params.enterpriseName,
        user: params.user,
        password: params.password,
      ),
    );
    final model = FirebaseEnterpriseModel.fromEntity(enterprise);

    await _datasource.saveEnterprises([...savedEnterprises, model]);
    final selectedEnterprise = await _datasource.loadSelectedEnterprise();
    if (selectedEnterprise == null) {
      await _datasource.saveSelectedEnterprise(model);
    }

    return enterprise;
  }

  @override
  Future<void> removeEnterprise(FirebaseEnterpriseEntity enterprise) async {
    final selectedEnterprise = await _datasource.loadSelectedEnterprise();
    if (_isSameEnterprise(selectedEnterprise?.toEntity(), enterprise)) {
      throw AppException('A empresa ativa não pode ser removida.');
    }

    final savedEnterprises = await _datasource.loadEnterprises();
    final remainingEnterprises = savedEnterprises
        .where((model) => !_isSameEnterprise(model.toEntity(), enterprise))
        .toList(growable: false);
    if (remainingEnterprises.length == savedEnterprises.length) {
      throw AppException('A empresa não foi encontrada.');
    }

    await _datasource.saveEnterprises(remainingEnterprises);
  }

  bool _isSameEnterprise(
    FirebaseEnterpriseEntity? first,
    FirebaseEnterpriseEntity second,
  ) {
    if (first == null) return false;
    if (first.firebaseId != null && second.firebaseId != null) {
      return first.firebaseId == second.firebaseId;
    }
    return _normalize(first.enterpriseName) ==
        _normalize(second.enterpriseName);
  }

  String _normalize(String? value) =>
      (value ?? '').trim().toLowerCase().removeWhiteSpaces();
}
