import 'dart:convert';

import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class SoapAdapter implements SoapRequest {
  @override
  Future<dynamic> post({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
    required String url,
  }) async {
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

      final envelope =
          '''<?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <$soapAction xmlns="http://celtaware.com.br/">
          $parameterTags
          </$soapAction>
        </soap12:Body>
      </soap12:Envelope>''';

      final response = await http
          .post(
            Uri.parse('$url/ccs/$serviceASMX'),
            body: envelope,
            headers: soapHeaders,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase ?? response.body);
      }

      final Xml2Json xml2json = Xml2Json();
      xml2json.parse(response.body);
      final parsedJson = json.decode(xml2json.toParker());

      final responseBody =
          parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse];

      if (responseBody["status"] == "OK") {
        return _handleSuccessResponse(responseBody, typeOfResult);
      } else {
        throw Exception(responseBody["status"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  String _handleSuccessResponse(
    Map<String, dynamic> responseBody,
    String? typeOfResult,
  ) {
    if (typeOfResult != null && responseBody[typeOfResult] != null) {
      if (_isValidResponse(responseBody, typeOfResult)) {
        return responseBody[typeOfResult]["diffgr:diffgram"]["NewDataSet"]
            .toString();
      }
      return responseBody[typeOfResult].toString();
    } else if (responseBody.toString().contains("sucesso")) {
      return responseBody["status"][typeOfResult];
    }
    throw Exception('Invalid response structure');
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
