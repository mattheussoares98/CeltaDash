// test/features/home/presentation/pages/financial/financial_periods_page_test.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/domain/repository/repository.dart';
import 'package:celta_dash/features/financial_titles/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';
import '../../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../../app_analytics/mocks/mocks.dart';
import '../../../mocks/mocks.dart';

class MockFinancialTitlesRepository extends Mock
    implements IFinancialTitlesRepository {}

void main() {
  late MockFinancialTitlesRepository repository;
  late MockAppAnalyticsRepository analyticsRepository;
  late EcParams ecParams;
  const enterpriseId = 10;
  final selectedDate = DateTime(2026, 8, 17);

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    registerFallbackValue(EntityFactory.makeEcParams());

    registerFallbackValue(
      SearchFinancialTitleDataParams(
        startDate: DateTime(2026),
        endDate: DateTime(2026, 1, 31),
        enterpriseCodes: const [1],
      ),
    );
  });

  setUp(() {
    repository = MockFinancialTitlesRepository();
    analyticsRepository = MockAppAnalyticsRepository();
    ecParams = EntityFactory.makeEcParams();
    when(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.financial,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    ).thenAnswer((_) async {});
  });

  Widget makeTestableWidget({
    FinancialTitleDataResponseEntity response =
        const FinancialTitleDataResponseEntity(),
  }) {
    final requestParams = SearchFinancialTitleDataParams(
      enterpriseCodes: const [enterpriseId],
      startDate: DateTime(2026, 8),
      endDate: DateTime(2026, 8, 31),
      periodGrouping: FinancialTitlePeriodGrouping.day,
      periodType: FinancialTitlePeriodType.expiration,
    );
    when(
      () => repository.getData(params: requestParams, ecParams: ecParams),
    ).thenAnswer((_) async => response);

    return ProviderScope(
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => FakeActiveEcParams(ecParams),
        ),
        homeControllerProvider.overrideWith(
          () => FakeHomeController(
            HomeState.initial(appMode: AppMode.financialTitles).copyWith(
              selectedEnterpriseId: enterpriseId,
              selectedDate: selectedDate,
            ),
          ),
        ),
        financialTitlesRepositoryProvider.overrideWithValue(repository),
        appAnalyticsRepositoryProvider.overrideWithValue(analyticsRepository),
      ],
      child: const MaterialApp(home: Scaffold(body: FinancialPeriodsPage())),
    );
  }

  testWidgets('renders segmented buttons for period selection', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Dia'), findsOneWidget);
    expect(find.text('Mês'), findsOneWidget);
  });

  testWidgets('renders empty placeholder when no data exists', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Nenhum título encontrado'), findsOneWidget);
  });

  testWidgets('renders financial table when records exist', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        response: FinancialTitleDataResponseEntity(
          financialTitlePortions: [
            FinancialTitleDataRowEntity(
              enterpriseCode: enterpriseId,
              date: DateTime(2026, 8, 17),
              receiveLiquidValue: 1500,
              payLiquidValue: 500,
              liquidBalanceValue: 1000,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byType(ScrollableTable<FinancialStatisticsRowState>),
      findsOneWidget,
    );
    expect(find.textContaining('Receber', findRichText: true), findsWidgets);
    expect(find.textContaining('Pagar', findRichText: true), findsWidgets);
    expect(find.textContaining('Saldo', findRichText: true), findsWidgets);
  });
}
