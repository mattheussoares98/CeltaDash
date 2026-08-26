import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/web_enterprises/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:celta_dash/utils/utils.dart';

class WebEnterprisesRepositoryImpl implements IWebEnterprisesRepository {
  final IWebEnterprisesDatasource datasource;

  const WebEnterprisesRepositoryImpl(this.datasource);

  @override
  Future<List<FirebaseEnterpriseEntity>> getEnterprises() async {
    final models = await datasource.getEnterprises();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<FirebaseEnterpriseEntity> createEnterprise(
    CreateWebEnterpriseParams params,
  ) async {
    final user = await datasource.authenticateBs(params);
    final accessKey = user.accessKey;
    if (accessKey == null || accessKey.isEmpty) {
      throw AppException(
        'Atualize o Celta BS para cadastrar esta empresa'.hardcoded,
      );
    }
    final candidates = await datasource.getCandidateEnterprises(
      baseUrl: params.normalizedBaseUrl,
      user: params.user,
      accessKey: accessKey,
    );
    final enterprise = FirebaseEnterpriseEntity(
      baseUrl: params.normalizedBaseUrl,
      enterpriseName: params.normalizedEnterpriseName,
      bsUser: null,
      firebaseSubEnterprises: candidates
          .map((candidate) => candidate.toEntity())
          .toList(growable: false),
      firebaseId: params.normalizedEnterpriseName,
    );
    await datasource.createEnterprise(
      FirebaseEnterpriseModel.fromEntity(enterprise),
    );
    return enterprise;
  }

  @override
  Future<void> updateEnterprise(FirebaseEnterpriseEntity enterprise) =>
      datasource.updateEnterprise(
        FirebaseEnterpriseModel.fromEntity(enterprise),
      );
}
