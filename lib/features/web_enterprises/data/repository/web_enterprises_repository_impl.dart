import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/web_enterprises/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';

class WebEnterprisesRepositoryImpl implements IWebEnterprisesRepository {
  final IWebEnterprisesDatasource datasource;

  const WebEnterprisesRepositoryImpl(this.datasource);

  @override
  Future<List<FirebaseEnterpriseEntity>> getEnterprises() =>
      datasource.getEnterprises();

  @override
  Future<List<MonthlyAnalyticsEntity>> getAnalytics(DateTime period) =>
      datasource.getAnalytics(period);
}
