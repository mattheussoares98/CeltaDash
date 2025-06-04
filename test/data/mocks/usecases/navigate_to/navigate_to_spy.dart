

import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class NavigateToSpy extends Mock implements NavigateTo {
  NavigateToSpy() {
    this.mockNavigate();
  }

  When mockNavigateCall() => when(
    () => this.navigate(
      pageRoute: any(named: 'pageRoute'),
      clear: any(named: 'clear'),
    ),
  );

  void mockNavigate() {
    this.mockNavigateCall().thenAnswer((any) async => any);
  }

  void mockNavigateError() {
    this.mockNavigateCall().thenThrow(Exception());
  }
}
