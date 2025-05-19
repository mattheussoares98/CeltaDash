import 'dart:convert';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

import '../../data/http/http.dart';
import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../main/builders/builders.dart';

class SoapAdapter implements SoapRequest {
  @override
  Future<SoapResponseModel> post({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
    String? url,
  }) async {
    late SoapResponseModel soapResponse;

    try {
      final soapHeaders = {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://celtaware.com.br/$soapAction',
        'Accept-Language': 'en-US',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
      };

      String parameterTags = '';

      parameters.forEach((tag, value) {
        parameterTags += '<$tag>$value</$tag>\n';
      });

      final envelope = '''<?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <$soapAction xmlns="http://celtaware.com.br/">
          $parameterTags
          </$soapAction>
        </soap12:Body>
      </soap12:Envelope>''';

      final baseUrl = url ?? EnterpriseBuilder.entity?.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/ccs/$serviceASMX'),
        body: envelope,
        headers: soapHeaders,
      );

      if (response.statusCode != 200) {
        throw DomainError.unexpected;
      }

      final Xml2Json xml2json = Xml2Json();
      xml2json.parse(response.body);
      final parsedJson = json.decode(xml2json.toParker());

      final responseBody =
          parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse];

      if (responseBody["status"] == "OK") {
        soapResponse = _handleSuccessResponse(responseBody, typeOfResult);
      } else {
        soapResponse = _handleErrorResponse(responseBody, typeOfResult);
      }

      return soapResponse;
    } catch (e) {
      rethrow;
    }
  }

  SoapResponseModel _handleSuccessResponse(
    Map<String, dynamic> responseBody,
    String? typeOfResult,
  ) {
    if (typeOfResult != null && responseBody[typeOfResult] != null) {
      if (_isValidResponse(responseBody, typeOfResult)) {
        return SoapResponseModel(
          response: responseBody[typeOfResult]["diffgr:diffgram"]["NewDataSet"]
              .toString(),
          responseType: SoapResponseType.success,
        );
      }
      return SoapResponseModel(
        response: responseBody[typeOfResult].toString(),
        responseType: SoapResponseType.success,
      );
    }
    return SoapResponseModel(
      response: 'Invalid response structure',
      responseType: SoapResponseType.error,
    );
  }

  SoapResponseModel _handleErrorResponse(
    Map<String, dynamic> responseBody,
    String? typeOfResult,
  ) {
    if (responseBody.toString().contains("sucesso")) {
      return SoapResponseModel(
        response: responseBody["status"][typeOfResult],
        responseType: SoapResponseType.success,
      );
    }
    return SoapResponseModel(
      response: responseBody["status"],
      responseType: SoapResponseType.error,
    );
  }

  bool _isValidResponse(
    Map<String, dynamic> responseBody,
    String typeOfResult,
  ) {
    try {
      return responseBody[typeOfResult]?["diffgr:diffgram"]?["NewDataSet"] !=
          null;
    } catch (e) {
      return false;
    }
  }
}
