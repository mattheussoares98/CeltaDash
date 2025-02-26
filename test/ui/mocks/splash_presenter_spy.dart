import 'package:celta_plus/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  SplashPresenterSpy() {
    when(
      () => this.checkPageToGo(
        durationInSeconds: any(named: 'durationInSeconds'),
        atualDate: any(named: 'atualDate'),
      ),
    ).thenAnswer((any) async => any);
  }

  // void mockLoadAccount(CrossIdEntity? crossIdEntity) {
  //   when(() => this.load()).thenAnswer((_) async => crossIdEntity);
  // }
}
