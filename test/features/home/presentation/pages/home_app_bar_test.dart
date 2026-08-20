import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockHomeRepository repository;
  late EcParams ecParams;
  late HomeEnterpriseEntity enterprise;
  late FirebaseEnterpriseEntity activeEnterprise;

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    repository = MockHomeRepository();
    ecParams = EntityFactory.makeEcParams();
    enterprise = HomeEntityFactory.makeHomeEnterpriseEntity(id: 1);
    activeEnterprise = EntityFactory.makeFirebaseEnterpriseEntity().copyWith(
      firebaseSubEnterprises: [
        EntityFactory.makeFirebaseSubEnterpriseEntity(id: 1, enabled: true),
      ],
    );
    when(() => repository.loadAppMode()).thenAnswer((_) async => AppMode.sales);
    when(
      () => repository.loadActiveEnterprise(),
    ).thenAnswer((_) async => activeEnterprise);
    when(
      () => repository.getEnterprises(ecParams),
    ).thenAnswer((_) async => [enterprise]);
    when(
      () => repository.saveAppMode(AppMode.financialTitles),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpAppBar(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeEcParamsStateControllerProvider.overrideWith(
            () => FakeActiveEcParams(ecParams),
          ),
          homeRepositoryProvider.overrideWithValue(repository),
        ],
        child: ToastificationWrapper(
          child: const MaterialApp(
            home: Scaffold(
              appBar: HomeAppBar(
                isLandscape: false,
                showToggleAppMode: true,
                showEnterpriseManagement: true,
              ),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows enterprise, date, mode, and manager controls', (
    tester,
  ) async {
    await pumpAppBar(tester);

    expect(
      find.byKey(const ValueKey('home_enterprise_selector')),
      findsWidgets,
    );
    expect(find.byKey(const ValueKey('home_date_selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('home_mode_toggle')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('home_enterprises_manager')),
      findsOneWidget,
    );
  });

  testWidgets('persists and displays the changed app mode', (tester) async {
    await pumpAppBar(tester);

    await tester.tap(find.byKey(const ValueKey('home_mode_toggle')));
    await tester.pumpAndSettle();

    verify(() => repository.saveAppMode(AppMode.financialTitles)).called(1);
    expect(find.text('Financeiro'), findsOneWidget);
  });

  testWidgets('uses the horizontal control layout in landscape', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpAppBar(tester);

    final dateCenter = tester.getCenter(
      find.byKey(const ValueKey('home_date_selector')),
    );
    final enterpriseCenter = tester.getCenter(
      find.byKey(const ValueKey('home_enterprise_selector')).first,
    );
    expect((dateCenter.dy - enterpriseCenter.dy).abs(), lessThan(10));
  });

  testWidgets('AsyncValueWidget exposes retry and reloads the provider', (
    tester,
  ) async {
    when(
      () => repository.getEnterprises(ecParams),
    ).thenThrow(Exception('load failed'));
    await pumpAppBar(tester);
    expect(find.text('Tentar novamente'), findsOneWidget);

    when(
      () => repository.getEnterprises(ecParams),
    ).thenAnswer((_) async => [enterprise]);
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('home_enterprise_selector')),
      findsWidgets,
    );
  });
}
