import 'package:celta_dash/features/login/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/login/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockLoginRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockLoginRepository();
    container = ProviderContainer(
      overrides: [loginRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('returns the last enterprise name and username', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    when(() => repository.loadLastLogin()).thenAnswer((_) async => enterprise);

    final result = await container.read(loginPrefillControllerProvider.future);

    expect(result.enterpriseName, enterprise.enterpriseName);
    expect(result.username, enterprise.bsUser?.name);
    verify(() => repository.loadLastLogin()).called(1);
  });

  test('returns empty prefill when there is no saved enterprise', () async {
    when(() => repository.loadLastLogin()).thenAnswer((_) async => null);

    final result = await container.read(loginPrefillControllerProvider.future);

    expect(result.enterpriseName, isNull);
    expect(result.username, isNull);
  });
}
