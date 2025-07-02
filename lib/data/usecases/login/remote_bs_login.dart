import 'dart:convert';

import 'package:xml2json/xml2json.dart';

import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteBsLogin with ErrorHandling implements BsLogin {
  final SoapRequest soapAdapter;

  RemoteBsLogin(this.soapAdapter);

  @override
  Future<dynamic> login({
    required String user,
    required String password,
    required String? url,
  }) async {
    try {
      final response = await soapAdapter.post(
        parameters: {"user": user, "password": password},
        typeOfResponse: "UserCanLoginJsonResponse",
        soapAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
        url: url,
      );

      var userUpdated = {};

      Map resultAsMap = json.decode(response);
      userUpdated = resultAsMap["Usuarios"][0];

      final myTransformer = Xml2Json();
      myTransformer.parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
      String toParker = myTransformer.toParker();
      Map toParker2 = json.decode(toParker);
      userUpdated["CrossIdentity_Usuario"] = toParker2["string"];

      return userUpdated;
    } catch (e) {
      treatError(e);
    }
  }
}
