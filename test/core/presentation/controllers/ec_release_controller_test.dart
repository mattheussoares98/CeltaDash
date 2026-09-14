import 'package:celta_dash/core/domain/entities/entities.dart';
import 'package:celta_dash/core/presentation/presentation.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/utils/extensions/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../features/buy_movement/mocks/mocks.dart';
import '../../mocks/mock_ec_release_repository.dart';

void main() {
  late MockEcReleaseRepository repository;
  late ProviderContainer container;
  late EcParams ecParams;

  setUp(() {
    ecParams = EntityFactory.makeEcParams();
    repository = MockEcReleaseRepository();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ecReleaseRepositoryProvider.overrideWithValue(repository),
        activeEcParamsStateControllerProvider.overrideWith(
          () => MutableActiveEcParams(ecParams),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('build loads the release date from the repository', () async {
    final releasedAtUtc = DateTime.utc(2026, 9, 14, 17);
    when(
      () => repository.getReleasedAtUtc(ecParams),
    ).thenAnswer((_) async => releasedAtUtc);

    final result = await container.read(ecReleaseControllerProvider.future);

    expect(result, releasedAtUtc);
    verify(() => repository.getReleasedAtUtc(ecParams)).called(1);
  });
  test('build throws a localized exception when loading fails', () async {
    when(() => repository.getReleasedAtUtc(ecParams)).thenThrow(Exception());

    await expectLater(
      container.read(ecReleaseControllerProvider.future),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          'Exception: ${'Não foi possível carregar a data da versão do sistema. Entre em contato com o suporte técnico e solicite a atualização da API'.hardcoded}',
        ),
      ),
    );
    verify(() => repository.getReleasedAtUtc(ecParams)).called(1);
  });
}
