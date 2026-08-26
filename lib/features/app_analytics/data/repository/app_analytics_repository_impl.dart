import 'package:celta_dash/features/app_analytics/data/datasource/datasource.dart';
import 'package:celta_dash/features/app_analytics/data/models/models.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/enterprises_manager/data/datasource/datasource.dart';
import 'package:celta_dash/utils/utils.dart';

class AppAnalyticsRepositoryImpl implements IAppAnalyticsRepository {
  final IAppAnalyticsDatasource datasource;
  final IEnterprisesManagerDatasource enterprisesManagerDatasource;

  const AppAnalyticsRepositoryImpl({
    required this.datasource,
    required this.enterprisesManagerDatasource,
  });

  @override
  Future<List<AppAnalyticsEntity>> getAnalytics(DateTime period) async {
    final models = await datasource.getAnalytics(period);
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> addNewMonthlyAnalytic({
    required AppAnalyticsReportType reportType,
    required AppAnalyticsPeriodType periodType,
  }) async {
    try {
      final enterprise =
          await enterprisesManagerDatasource.loadSelectedEnterprise();
      final enterpriseName = enterprise?.enterpriseName;
      if (enterpriseName == null || enterpriseName.isEmpty) return;

      final enterpriseId = enterprise?.firebaseId ?? enterpriseName;
      final localData = await datasource.loadLocalMonthlyAnalytics(
        enterpriseId: enterpriseId,
      );

      final platform = _getPlatformName();
      final userName = enterprise?.bsUser?.name?.toLowerCase() ?? '';

      // Update Search Counts
      final searchCounts = List<AppAnalyticsSearchCountModel>.from(
        localData.searchCounts,
      );
      final searchIndex = searchCounts.indexWhere(
        (sc) => sc.reportType == reportType && sc.periodType == periodType,
      );

      if (searchIndex != -1) {
        final existing = searchCounts[searchIndex];
        searchCounts[searchIndex] = AppAnalyticsSearchCountModel(
          reportType: existing.reportType,
          periodType: existing.periodType,
          count: existing.count + 1,
        );
      } else {
        searchCounts.add(
          AppAnalyticsSearchCountModel(
            reportType: reportType,
            periodType: periodType,
            count: 1,
          ),
        );
      }

      // Update Users
      final users = List<AppAnalyticsUserModel>.from(localData.users);
      if (userName.isNotEmpty) {
        final userIndex = users.indexWhere(
          (u) => u.userName.toLowerCase() == userName,
        );
        if (userIndex != -1) {
          users[userIndex] = AppAnalyticsUserModel(
            userName: userName,
            platform: platform,
          );
        } else {
          users.add(
            AppAnalyticsUserModel(userName: userName, platform: platform),
          );
        }
      }

      final updatedModel = AppAnalyticsModel(
        searchCounts: searchCounts,
        users: users,
        enterprise: enterpriseId,
      );

      final now = DateTime.now();
      final lastSyncDate = await datasource.getLastSyncDate();
      final isSameDay =
          lastSyncDate != null &&
          lastSyncDate.year == now.year &&
          lastSyncDate.month == now.month &&
          lastSyncDate.day == now.day;

      if (!isSameDay) {
        final docId = now.formatDate(.yyyyMM);
        await datasource.syncAnalytics(
          docId: docId,
          enterpriseName: enterpriseName,
          model: updatedModel,
        );
        await datasource.clearLocalMonthlyAnalytics();
        await datasource.saveLastSyncDate(now);
      } else {
        await datasource.saveLocalMonthlyAnalytics(updatedModel);
      }
    } catch (_) {
      // Ignored for resilience
    }
  }

  String _getPlatformName() {
    if (PlatformUtil.isWeb) return 'web';
    if (PlatformUtil.isAndroid) return 'android';
    if (PlatformUtil.isIOS) return 'ios';
    if (PlatformUtil.isWindows) return 'windows';
    if (PlatformUtil.isMacOS) return 'macos';
    if (PlatformUtil.isLinux) return 'linux';
    return 'other';
  }
}
