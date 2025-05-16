import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../../data/http/http.dart';

class StaticHttpAdapter implements HttpClient {
  static final StaticHttpAdapter _instance =
      StaticHttpAdapter._internal(Client());

  final Client client;

  factory StaticHttpAdapter(Client client) {
    return _instance;
  }

  StaticHttpAdapter._internal(this.client);

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    dynamic body,
    Map? headers,
    bool? addDefaultHeaders = true,
    bool? decodeBody = true,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {};
    if (addDefaultHeaders == true) {
      defaultHeaders.addAll(
        {'content-type': 'application/json', 'accept': 'application/json'},
      );
    }
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response>? futureResponse;
    try {
      if (method == 'post') {
        futureResponse = client.post(Uri.parse(url),
            headers: defaultHeaders, body: jsonBody);
      } else if (method == 'get') {
        futureResponse = client.get(Uri.parse(url), headers: defaultHeaders);
      } else if (method == 'delete') {
        futureResponse = client.delete(Uri.parse(url), headers: defaultHeaders);
      } else if (method == 'put') {
        futureResponse =
            client.put(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      }
      if (futureResponse != null) {
        response = await futureResponse.timeout(const Duration(seconds: 60));
      }
    } catch (error) {
      debugPrint(error.toString());
      throw HttpError.serverError;
    }
    return _handleResponse(response, decodeBody);
  }

  dynamic _handleResponse(Response response, bool? decodeBody) {
    switch (response.statusCode) {
      case 200:
        return decodeBody != true
            ? response.body
            : (response.body.isEmpty ? null : jsonDecode(response.body));
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
