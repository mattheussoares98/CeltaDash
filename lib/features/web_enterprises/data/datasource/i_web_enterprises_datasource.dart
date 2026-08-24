import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/features/web_enterprises/data/models/models.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';

abstract class IWebEnterprisesDatasource {
  Future<List<FirebaseEnterpriseModel>> getEnterprises();

  Future<WebEnterpriseBsUserModel> authenticateBs(
    CreateWebEnterpriseParams params,
  );

  Future<List<WebEnterpriseCandidateModel>> getCandidateEnterprises({
    required String baseUrl,
    required String user,
    required String accessKey,
  });

  Future<void> createEnterprise(FirebaseEnterpriseModel enterprise);

  Future<void> updateEnterprise(FirebaseEnterpriseModel enterprise);

  Future<List<WebAnalyticsModel>> getAnalytics(DateTime period);
}
