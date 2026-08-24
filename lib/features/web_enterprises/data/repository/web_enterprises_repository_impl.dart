import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';

class WebEnterprisesRepositoryImpl implements IWebEnterprisesRepository {
  final IWebEnterprisesDatasource datasource;

  const WebEnterprisesRepositoryImpl(this.datasource);

  @override
  Future<List<FirebaseEnterpriseEntity>> getEnterprises() async {
    final models = await datasource.getEnterprises();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<List<WebAnalyticsEntity>> getAnalytics(DateTime period) async {
    final models = await datasource.getAnalytics(period);
    return models.map((model) => model.toEntity()).toList(growable: false);
  }
}
