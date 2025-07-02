import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  SplashPresenterSpy() {
    when(
      () => this.checkPageToGo(
        enterprisesManagerPresenter: any(named: 'enterprisesManagerPresenter'),
        durationInSeconds: any(named: 'durationInSeconds'),
      ),
    ).thenAnswer((any) async => any);
  }

  // void mockLoadAccount(CrossIdEntity? crossIdEntity) {
  //   when(() => this.load()).thenAnswer((_) async => crossIdEntity);
  // }
}
