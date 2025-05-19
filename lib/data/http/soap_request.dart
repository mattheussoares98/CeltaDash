import '../models/models.dart';

abstract class SoapRequest {
  Future<SoapResponseModel> post({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
    String? url,
  });
}
