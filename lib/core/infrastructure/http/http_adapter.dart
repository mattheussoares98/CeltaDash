import 'dart:convert';

import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

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
      defaultHeaders.addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
    }
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response>? futureResponse;

    String appliedUrl = url;

    const useLocalApi = bool.fromEnvironment('USE_LOCAL_API');
    const localApiHost = String.fromEnvironment('LOCAL_API_HOST');
    if (kDebugMode && useLocalApi && localApiHost.isNotEmpty) {
      appliedUrl = url.replaceFirstMapped(
        RegExp(r'(https?://)[^/]+/api'),
        (match) => '${match[1]}$localApiHost',
      );
    }
    try {
      if (method == 'post') {
        futureResponse = client.post(
          Uri.parse(appliedUrl),
          headers: defaultHeaders,
          body: jsonBody,
        );
      } else if (method == 'get') {
        futureResponse = client.get(
          Uri.parse(appliedUrl),
          headers: defaultHeaders,
        );
      } else if (method == 'delete') {
        futureResponse = client.delete(
          Uri.parse(appliedUrl),
          headers: defaultHeaders,
        );
      } else if (method == 'put') {
        futureResponse = client.put(
          Uri.parse(appliedUrl),
          headers: defaultHeaders,
          body: jsonBody,
        );
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
        response.body.isNotEmpty
            ? throw Exception(response.body)
            : throw HttpError.badRequest;
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
