import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

/// Thin wrapper around `http` that decodes JSON and translates non-success
/// responses into [ServerException]s for the data layer.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(String url) async {
    final response = await _client.get(Uri.parse(url));
    return _decode(response);
  }

  Future<dynamic> post(String url, {Object? body}) async {
    final response = await _client.post(Uri.parse(url), body: body);
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw ServerException(
      statusCode: response.statusCode,
      message: response.body,
    );
  }
}
