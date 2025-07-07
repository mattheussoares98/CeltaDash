import 'package:celta_dash/ui/services/services.dart';
import 'package:mocktail/mocktail.dart';

class AppAnalyticsServiceSpy extends Mock implements AppAnalyticsService {
  AppAnalyticsServiceSpy() {
    mockAddNewMonthlyAnalytic();
  }

  When _mockAddNewMonthlyAnalyticCall() =>
      when(() => this.addNewMonthlyAnalytic(
            reportType: any(named: "reportType"),
            reportPeriod: any(named: "reportPeriod"),
            userName: any(named: "userName"),
            platform: any(named: "platform"),
          ));

  void mockAddNewMonthlyAnalytic() =>
      _mockAddNewMonthlyAnalyticCall().thenAnswer((any) async => any);
  void mockAddNewMonthlyAnalyticError() =>
      _mockAddNewMonthlyAnalyticCall().thenThrow(Exception());
}
