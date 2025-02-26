

import 'package:celta_plus/data/http/http.dart';
import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {
  HttpClientSpy() {
    this.mockRequest(200);
  }

  When mockRequestCall() => when(() => this.request(
        url: any(named: "url"),
        method: any(named: "method"),
        body: any(named: "body"),
        headers: any(named: "headers"),
      ));
  void mockRequest(dynamic response) =>
      this.mockRequestCall().thenAnswer((any) async => response);
  void mockRequestError() =>
      when(() => this.mockRequestCall().thenThrow(DomainError.unexpected));
}
