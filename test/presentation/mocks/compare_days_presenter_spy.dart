import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class CompareDaysPresenterSpy extends Mock implements CompareDaysPresenter {
  CompareDaysPresenterSpy() {
    when(() => this.getSales(
          firstDay: any(named: "firstDay"),
          secondDay: any(named: "secondDay"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((any) async => any);
  }
}
