import '../../domain/entities/entities.dart';

abstract class AppAnalyticsService {
  Future<void> addNewMonthlyAnalytic({
    required ReportType reportType,
    required ReportPeriod reportPeriod,
    required String userName,
    required String platform,
  });
}
