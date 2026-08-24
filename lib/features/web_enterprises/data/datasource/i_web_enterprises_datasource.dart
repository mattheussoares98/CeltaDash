import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/features/web_enterprises/data/models/models.dart';

abstract class IWebEnterprisesDatasource {
  Future<List<FirebaseEnterpriseModel>> getEnterprises();

  Future<List<WebAnalyticsModel>> getAnalytics(DateTime period);
}
