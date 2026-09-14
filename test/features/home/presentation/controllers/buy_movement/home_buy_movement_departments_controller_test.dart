import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';
import '../../../../app_analytics/mocks/mocks.dart';
import '../../../../buy_movement/mocks/mocks.dart';
import '../../../mocks/mocks.dart';

void main() {
  late MockBuyMovementRepository repository;
  late MockAppAnalyticsRepository analyticsRepository;
  late ProviderContainer container;
  late EcParams ecParams;
  final selectedDate = DateTime(2026, 8, 19);
  const enterpriseId = 10;

  setUp(() {
    repository = MockBuyMovementRepository();
    analyticsRepository = MockAppAnalyticsRepository();
    ecParams = EntityFactory.makeEcParams();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => MutableActiveEcParams(ecParams),
        ),
        homeControllerProvider.overrideWith(
          () => FakeHomeController(
            HomeState.initial(appMode: AppMode.buyMovements).copyWith(
              selectedEnterpriseId: enterpriseId,
              selectedDate: selectedDate,
            ),
          ),
        ),
        buyMovementRepositoryProvider.overrideWithValue(repository),
        appAnalyticsRepositoryProvider.overrideWithValue(analyticsRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('loads the selected week grouped only by department', () async {
    final params = SearchBuyMovementDataParamsEntity(
      enterpriseCodes: const [enterpriseId],
      startDate: DateTime(2026, 8, 17),
      endDate: DateTime(2026, 8, 23),
      groupByProductDepartment: true,
    );
    final response = BuyMovementEntityFactory.makeResponseEntity(
      searchParameters: params,
      results: [
        BuyMovementEntityFactory.makeDataRowEntity(
          withProduct: false,
          withProductDepartment: true,
          withSupplier: false,
        ),
      ],
    );
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => response);
    when(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementDepartments,
        periodType: AppAnalyticsPeriodType.weekly,
      ),
    ).thenAnswer((_) async {});

    final result = await container.read(
      homeBuyMovementDepartmentsControllerProvider(
        enterpriseId,
        BuyMovementDepartmentsPeriod.weekly,
      ).future,
    );

    expect(result, response.results);
    verify(
      () => repository.getData(params: params, ecParams: ecParams),
    ).called(1);
    verify(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementDepartments,
        periodType: AppAnalyticsPeriodType.weekly,
      ),
    ).called(1);
  });
}
