import 'package:celta_dash/domain/entities/entities.dart';

abstract class IWebEnterprisesDatasource {
  Future<List<FirebaseEnterpriseEntity>> getEnterprises();

  Future<List<MonthlyAnalyticsEntity>> getAnalytics(DateTime period);
}
