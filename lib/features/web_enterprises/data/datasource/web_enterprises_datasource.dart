import 'dart:convert';

import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/web_enterprises/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_enterprises/data/models/models.dart';
import 'package:celta_dash/features/web_enterprises/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:xml2json/xml2json.dart';

class WebEnterprisesDatasource implements IWebEnterprisesDatasource {
  final FirebaseStorage firebaseStorage;
  final SoapRequest soapRequest;
  final HttpClient httpClient;

  const WebEnterprisesDatasource({
    required this.firebaseStorage,
    required this.soapRequest,
    required this.httpClient,
  });

  @override
  Future<List<FirebaseEnterpriseModel>> getEnterprises() async {
    final snapshot = await firebaseStorage.get(path: 'enterprises');
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<FirebaseEnterpriseModel?>(_parseEnterprise)
        .whereType<FirebaseEnterpriseModel>()
        .toList(growable: false);
  }

  @override
  Future<WebEnterpriseBsUserModel> authenticateBs(
    CreateWebEnterpriseParams params,
  ) async {
    final response = await soapRequest.post(
      parameters: {'user': params.user, 'password': params.password},
      typeOfResponse: 'UserCanLoginJsonResponse',
      soapAction: 'UserCanLoginJson',
      serviceASMX: 'CeltaSecurityService.asmx',
      typeOfResult: 'UserCanLoginJsonResult',
      url: params.normalizedBaseUrl,
    );
    final decoded = json.decode(response as String) as Map;
    final users = decoded['Usuarios'] as List?;
    if (users == null || users.isEmpty) {
      throw AppException('Usuário ou senha inválidos'.hardcoded);
    }

    final user = Map.of(users.first as Map);
    final crossIdentity = user['CrossIdentity_Usuario'] as String?;
    if (crossIdentity != null && crossIdentity.isNotEmpty) {
      final transformer = Xml2Json()..parse(crossIdentity);
      final parsed = json.decode(transformer.toParker()) as Map;
      user['CrossIdentity_Usuario'] = parsed['string'];
    }
    return WebEnterpriseBsUserModel.fromJson(user);
  }

  @override
  Future<List<WebEnterpriseCandidateModel>> getCandidateEnterprises({
    required String baseUrl,
    required String user,
    required String accessKey,
  }) async {
    final response = await httpClient.request(
      url: '$baseUrl/api/enterprises',
      method: 'get',
      headers: {'user': user, 'accessKey': accessKey},
    );
    return (response as List)
        .map((item) => WebEnterpriseCandidateModel.fromJson(item as Map))
        .toList(growable: false);
  }

  @override
  Future<void> createEnterprise(FirebaseEnterpriseModel enterprise) async {
    final firebaseId = enterprise.firebaseId;
    if (firebaseId == null || firebaseId.isEmpty) {
      throw ArgumentError.value(firebaseId, 'firebaseId');
    }
    await firebaseStorage.put(
      path: 'enterprises/$firebaseId',
      data: <String, dynamic>{
        'baseUrl': enterprise.baseUrl,
        'enterpriseName': enterprise.enterpriseName,
        'subEnterprises': enterprise.subEnterprises
            ?.map((subEnterprise) => subEnterprise.toJson())
            .toList(growable: false),
      },
    );
  }

  @override
  Future<void> updateEnterprise(FirebaseEnterpriseModel enterprise) async {
    final firebaseId = enterprise.firebaseId;
    if (firebaseId == null || firebaseId.isEmpty) {
      throw ArgumentError.value(firebaseId, 'firebaseId');
    }

    await firebaseStorage.put(
      path: 'enterprises/$firebaseId',
      data: <String, dynamic>{
        'baseUrl': enterprise.baseUrl,
        'subEnterprises': enterprise.subEnterprises
            ?.map((subEnterprise) => subEnterprise.toJson())
            .toList(growable: false),
      },
      merge: true,
    );
  }

  @override
  Future<List<WebAnalyticsModel>> getAnalytics(DateTime period) async {
    final month = DateFormat('yyyy-MM').format(period);
    final snapshot = await firebaseStorage.get(
      path: 'analytics/$month/informations',
    );
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<WebAnalyticsModel?>(_parseAnalytics)
        .whereType<WebAnalyticsModel>()
        .toList(growable: false);
  }

  FirebaseEnterpriseModel? _parseEnterprise(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return FirebaseEnterpriseModel.fromJson(
      data,
      documentId: document.id as String?,
    );
  }

  WebAnalyticsModel? _parseAnalytics(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return WebAnalyticsModel.fromJson(
      data,
      enterpriseId: document.id as String,
    );
  }

  dynamic _readDocuments(dynamic snapshot) {
    try {
      return snapshot?.docs;
    } catch (_) {
      return null;
    }
  }
}
