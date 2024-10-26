import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/clsLogin.dart';
import '../constants.dart';

class ApiService {


  // Generic API call method
  Future<http.Response> apiCall(String endpoint, {String method = 'GET', Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    http.Response response;

    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(
          url,
          headers: headers ?? {'Content-Type': 'application/json'},
          body: body != null ? json.encode(body) : null,
        );
        break;

      case 'PUT':
        response = await http.put(
          url,
          headers: headers ?? {'Content-Type': 'application/json'},
          body: body != null ? json.encode(body) : null,
        );
        break;

      case 'DELETE':
        response = await http.delete(
          url,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;

      case 'GET':
      default:
        response = await http.get(
          url,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;
    }

    return response;
  }

}
