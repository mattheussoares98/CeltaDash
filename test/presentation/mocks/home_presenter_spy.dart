import 'package:celta_plus/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class HomePresenterSpy extends Mock implements HomePresenter {
  DateTime selectedDateMock = DateTime.now();
  EnterpriseViewModel? selectedEnterpriseMock;
  List<EnterpriseViewModel>? enterprisesMock;

  HomePresenterSpy() {
    this.mockSelectedDate(DateTime.now());
    this.mockCurrentPageIndexStream(Stream.value(0));

    when(() => this.selectedDate).thenAnswer((_) => selectedDateMock);
    when(() => this.enterprises).thenAnswer((_) => enterprisesMock);
    when(() => this.selectedEnterprise)
        .thenAnswer((_) => selectedEnterpriseMock);
  }

  When _mockUpdateSelectedIndexCall() =>
      when(() => this.updateSelectedIndex(any()));
  void mockUpdateSelectedIndex() =>
      _mockUpdateSelectedIndexCall().thenReturn(null);

  When _mockUpdateSelectedDateCall() =>
      when(() => this.updateSelectedDate(any()));
  void mockUpdateSelectedDate() =>
      _mockUpdateSelectedDateCall().thenReturn(null);

  When _mockSelectedDateCall() => when(() => selectedDate);
  void mockSelectedDate(DateTime value) =>
      _mockSelectedDateCall().thenReturn(value);

  When _mockCurrentPageIndexStreamCall() => when(() => currentPageIndexStream);
  void mockCurrentPageIndexStream(Stream<int> stream) =>
      _mockCurrentPageIndexStreamCall().thenAnswer((_) => stream);
}
