import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';

abstract class AppAnalyticsService {
  Future<void> addNewMonthlyAnalytic({
    required ReportType reportType,
    required PeriodType periodType,
  });
}
