import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class EnterprisesManagerPresenterSpy extends Mock
    implements EnterprisesManagerPresenter {
  FirebaseEnterpriseViewModel? selectedEnterpriseMock;

  EnterprisesManagerPresenterSpy() {
    when(() => this.selectedEnterprise)
        .thenAnswer((_) => selectedEnterpriseMock);

    _mockUpdateSelectedEnterpriseCall().thenAnswer((any) async => any);
  }

  When _mockUpdateSelectedEnterpriseCall() =>
      when(() => this.updateSelectedEnterprise(any()));

  void mockUpdateSelectedEnterpriseError() {
    _mockUpdateSelectedEnterpriseCall().thenThrow(DomainError.unexpected);
  }
}
