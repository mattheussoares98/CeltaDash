import 'package:celta_dash/data/usecases/usecases.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late LocalManageAppMode sut;
  late LocalStorageSpy localStorage;

  setUpAll(() {
    registerFallbackValue(DatabaseKeys.appMode);
  });

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalManageAppMode(localStorage);
  });

  test('Should load the selected mode', () async {
    localStorage.mockGet(
      DatabaseKeys.appMode,
      AppMode.financialTitles.name,
    );

    final mode = await sut.load();

    expect(mode, AppMode.financialTitles);
    verify(() => localStorage.get(DatabaseKeys.appMode)).called(1);
  });

  test('Should default to sales when no mode is stored', () async {
    localStorage.mockGet(DatabaseKeys.appMode, null);

    final mode = await sut.load();

    expect(mode, AppMode.sales);
  });

  test('Should default to sales when the stored mode is invalid', () async {
    localStorage.mockGet(DatabaseKeys.appMode, 'invalid');

    final mode = await sut.load();

    expect(mode, AppMode.sales);
  });

  test('Should change the selected mode', () async {
    await sut.change(AppMode.financialTitles);

    verify(
      () => localStorage.put(
        DatabaseKeys.appMode,
        AppMode.financialTitles.name,
      ),
    ).called(1);
  });
}
