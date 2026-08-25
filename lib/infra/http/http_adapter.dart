import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:celta_dash/core/infrastructure/http/http.dart';
import '../helpers/helpers.dart';

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

    String applyedUrl = url;

    //! replace easily when testing the API
    if (kDebugMode && 1 == 1) {
      applyedUrl = url.replaceFirstMapped(
        RegExp(r'https?://.+?/api', caseSensitive: false),
        (match) => 'http://localhost:58915',
      );
    }
    try {
      if (method == 'post') {
        futureResponse = client.post(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
          body: jsonBody,
        );
      } else if (method == 'get') {
        futureResponse = client.get(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
        );
      } else if (method == 'delete') {
        futureResponse = client.delete(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
        );
      } else if (method == 'put') {
        futureResponse = client.put(
          Uri.parse(applyedUrl),
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
            ? throw ApiError(response.body)
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
