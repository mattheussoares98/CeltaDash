import 'dart:convert';

import 'package:xml2json/xml2json.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class BsRemoteLogin implements RemoteLogin {
  final SoapRequest soapAdapter;

  BsRemoteLogin(this.soapAdapter);

  @override
  Future<SoapResponseModel> login({
    required String user,
    required String password,
  }) async {
    try {
      final baseUrl = EnterpriseBuilder.entity?.baseUrl;
      final response = await soapAdapter.post(
        parameters: {"user": user, "password": password},
        typeOfResponse: "UserCanLoginJsonResponse",
        soapAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
        ccsUrl: "$baseUrl/ccs",
      );

      if (response.responseType == SoapResponseType.error) return response;

      var userUpdated = {};

      Map resultAsMap = json.decode(response.response);
      userUpdated = resultAsMap["Usuarios"][0];

      final myTransformer = Xml2Json();
      myTransformer.parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
      String toParker = myTransformer.toParker();
      Map toParker2 = json.decode(toParker);
      userUpdated["CrossIdentity_Usuario"] = toParker2["string"];

      return SoapResponseModel(
        response: userUpdated,
        responseType: SoapResponseType.success,
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
