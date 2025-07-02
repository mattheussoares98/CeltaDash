abstract class SoapRequest {
  Future<dynamic> post({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
    required String url,
  });
}
