// lib/features/login/data/datasource/login_bs_auth_datasource.dart
import 'dart:convert';

import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/login/data/datasource/i_login_bs_auth_datasource.dart';
import 'package:celta_dash/features/login/data/models/models.dart';
import 'package:xml2json/xml2json.dart';

class LoginBsAuthDatasource implements ILoginBsAuthDatasource {
  final SoapRequest soapRequest;

  const LoginBsAuthDatasource(this.soapRequest);

  @override
  Future<BsUserModel> authenticateBs({
    required String user,
    required String password,
    required String url,
  }) async {
    try {
      final response = await soapRequest.post(
        parameters: {'user': user, 'password': password},
        typeOfResponse: 'UserCanLoginJsonResponse',
        soapAction: 'UserCanLoginJson',
        serviceASMX: 'CeltaSecurityService.asmx',
        typeOfResult: 'UserCanLoginJsonResult',
        url: url,
      );

      final Map resultAsMap = json.decode(response);
      final List users = resultAsMap['Usuarios'] as List;
      if (users.isEmpty) {
        throw DomainError.unexpected;
      }

      final Map userMap = Map.from(users.first as Map);

      final myTransformer = Xml2Json();
      myTransformer.parse(userMap['CrossIdentity_Usuario'] as String);
      final String toParker = myTransformer.toParker();
      final Map parsedParker = json.decode(toParker);
      userMap['CrossIdentity_Usuario'] = parsedParker['string'];

      final bsUserModel = BsUserModel.fromJson(userMap);
      if (bsUserModel.accessKey == null) {
        throw DomainError.updateCeltaBs;
      }

      return bsUserModel;
    } catch (e) {
      if (e is DomainError) rethrow;
      throw DomainError.unexpected;
    }
  }
}
