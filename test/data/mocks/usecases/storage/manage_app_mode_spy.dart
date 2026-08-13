import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ManageAppModeSpy extends Mock implements ManageAppMode {
  ManageAppModeSpy() {
    mockLoad(AppMode.sales);
    when(() => change(AppMode.sales)).thenAnswer((_) async {});
    when(() => change(AppMode.financialTitles)).thenAnswer((_) async {});
  }

  void mockLoad(AppMode mode) {
    when(load).thenAnswer((_) async => mode);
  }
}
