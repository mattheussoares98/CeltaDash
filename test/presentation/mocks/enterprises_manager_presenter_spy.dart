import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class EnterprisesManagerPresenterSpy extends Mock
    implements EnterprisesManagerPresenter {
  EnterprisesManagerPresenterSpy() {
    _mockAddNewEnterpriseCall().thenAnswer((any) async => true);
    _mockUpdateSelectedEnterpriseCall().thenAnswer((any) async => any);
    _mockLoadLocalEnterprisesCall().thenAnswer((any) async => any);
  }

  When _mockUpdateSelectedEnterpriseCall() =>
      when(() => this.updateSelectedEnterprise(any()));

  void mockUpdateSelectedEnterpriseError() {
    _mockUpdateSelectedEnterpriseCall().thenThrow(DomainError.unexpected);
  }

  When _mockLoadLocalEnterprisesCall() =>
      when(() => this.loadLocalEnterprises());

  void mockLoadLocalEnterprisesError() {
    _mockLoadLocalEnterprisesCall().thenThrow(DomainError.unexpected);
  }

  When _mockAddNewEnterpriseCall() => when(() => this.addNewEnterprise(
        enterpriseName: any(named: "enterpriseName"),
        userName: any(named: "userName"),
        userPassword: any(named: "userPassword"),
      ));

  void mockAddNewEnterpriseError() {
    _mockAddNewEnterpriseCall().thenThrow(DomainError.unexpected);
  }

  void mockAddNewEnterprise(bool value) {
    _mockAddNewEnterpriseCall().thenAnswer((any) async => value);
  }
}
