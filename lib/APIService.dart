import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'shared_preference.dart';

class ApiService {
  // Private method to get headers with authorization token
  static Future<Map<String, String>> _getHeaders() async {
    final token = SharedPrefs.getString(SharedPrefs.token);

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET Request
  static Future<http.Response> getRequest(String endpoint) async {
    final headers = await _getHeaders();
    return http.get(Uri.parse("$baseUrl$endpoint"), headers: headers);
  }

  // POST Request
  static Future<http.Response> postRequest(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  // PUT Request
  static Future<http.Response> putRequest(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  // DELETE Request
  static Future<http.Response> deleteRequest(String endpoint) async {
    final headers = await _getHeaders();
    return http.delete(Uri.parse("$baseUrl$endpoint"), headers: headers);
  }
}
