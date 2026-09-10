import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/data/datasource/datasource.dart';
import 'package:celta_dash/features/home/data/models/models.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/login/data/data.dart';

class HomeRepositoryImpl implements IHomeRepository {
  const HomeRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._goalDatasource,
    this._firebaseEnterpriseDatasource,
  );

  final IHomeDatasource _remoteDatasource;
  final IHomeLocalDatasource _localDatasource;
  final IHomeGoalDatasource _goalDatasource;
  final IFirebaseLoginEnterpriseDatasource _firebaseEnterpriseDatasource;

  @override
  Future<List<HomeEnterpriseEntity>> getEnterprises(EcParams ecParams) async {
    final models = await _remoteDatasource.getEnterprises(ecParams);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AppMode> loadAppMode() => _localDatasource.loadAppMode();

  @override
  Future<void> saveAppMode(AppMode mode) => _localDatasource.saveAppMode(mode);

  @override
  Future<FirebaseEnterpriseEntity?> loadActiveEnterprise() =>
      _localDatasource.loadActiveEnterprise();

  @override
  Future<List<MonthlyGoalEntity>> getMonthlyGoals({
    required String firebaseEnterpriseId,
    required int year,
  }) async {
    final models = await _goalDatasource.getMonthlyGoals(
      firebaseEnterpriseId: firebaseEnterpriseId,
      year: year,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveMonthlyGoal({
    required String firebaseEnterpriseId,
    required MonthlyGoalEntity goal,
  }) => _goalDatasource.saveMonthlyGoal(
    firebaseEnterpriseId: firebaseEnterpriseId,
    goal: MonthlyGoalModel.fromEntity(goal),
  );

  @override
  Future<void> syncSubEnterprises({
    required FirebaseEnterpriseEntity activeEnterprise,
    required List<HomeEnterpriseEntity> erpEnterprises,
  }) async {
    final firebaseId =
        (activeEnterprise.firebaseId != null &&
                activeEnterprise.firebaseId!.isNotEmpty)
            ? activeEnterprise.firebaseId!
            : (activeEnterprise.enterpriseName ?? '');
    if (firebaseId.isEmpty) return;

    final existingList =
        activeEnterprise.firebaseSubEnterprises ??
        const <FirebaseSubEnterpriseEntity>[];

    // Map existing enabled flags by store id (ERP code)
    final existingEnabledById = <int, bool>{};
    for (final sub in existingList) {
      if (sub.id != null) {
        existingEnabledById[sub.id!] = sub.enabled == true;
      }
    }

    // Build unique reconciled list based on ERP stores using ERP code (id)
    final seenIds = <int>{};
    final reconciled = <FirebaseSubEnterpriseEntity>[];

    for (final erp in erpEnterprises) {
      if (erp.id != null && seenIds.contains(erp.id)) continue;
      if (erp.id != null) seenIds.add(erp.id!);

      final isEnabled =
          erp.id != null ? (existingEnabledById[erp.id!] ?? false) : false;

      reconciled.add(
        FirebaseSubEnterpriseEntity(
          id: erp.id,
          name: erp.name,
          personalizedCode: erp.personalizedCode,
          cnpj: erp.cnpj,
          enabled: isEnabled,
        ),
      );
    }

    // Check if there is any difference between existingList and reconciled
    final hasDifference = _hasSubEnterpriseDifferences(existingList, reconciled);

    if (hasDifference) {
      final models = reconciled
          .map(FirebaseSubEnterpriseModel.fromEntity)
          .toList(growable: false);

      await _firebaseEnterpriseDatasource.updateSubEnterprises(
        firebaseId: firebaseId,
        subEnterprises: models,
      );
    }
  }

  bool _hasSubEnterpriseDifferences(
    List<FirebaseSubEnterpriseEntity> existing,
    List<FirebaseSubEnterpriseEntity> updated,
  ) {
    if (existing.length != updated.length) return true;
    for (var i = 0; i < existing.length; i++) {
      final e = existing[i];
      final u = updated[i];
      if (e.id != u.id ||
          e.name != u.name ||
          e.personalizedCode != u.personalizedCode ||
          e.cnpj != u.cnpj ||
          e.enabled != u.enabled) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> logout() => _localDatasource.logout();
}
