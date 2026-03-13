import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({
    this.baseUrl = 'http://localhost:8080',
    this.defaultHeaders = const {'X-Demo-User-Id': '1', 'Content-Type': 'application/json'},
  });

  Future<dynamic> getJson(String path, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse('$baseUrl$path'), headers: {...defaultHeaders, ...?headers});
    if (response.statusCode >= 400) {
      throw Exception('Request failed (${response.statusCode}): ${response.body}');
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postJson(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {...defaultHeaders, ...?headers},
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      throw Exception('Request failed (${response.statusCode}): ${response.body}');
    }
    return jsonDecode(response.body);
  }
}
