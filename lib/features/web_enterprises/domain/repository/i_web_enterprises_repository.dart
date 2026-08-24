import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/domain/entities/entities.dart';

abstract class IWebEnterprisesRepository {
  Future<List<FirebaseEnterpriseEntity>> getEnterprises();

  Future<List<WebAnalyticsEntity>> getAnalytics(DateTime period);
}
