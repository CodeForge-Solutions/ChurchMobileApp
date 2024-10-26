import 'dart:convert';
import 'package:flutter/material.dart';
import '../Models/clsLogin.dart';
import 'api_service.dart';

class LoginController {
  final ApiService _apiService = ApiService(); // Create an instance of ApiService

  Future<bool> login(BuildContext context, ClsLogin user) async {
    // Simulate login API call (replace with actual API integration)
    try {
      // Create the request body
      final body = {
        'phoneNumber': user.phoneNumber,
        'password': user.password,
      };

      // Call the API
      final response = await _apiService.apiCall('login', method: 'POST', body: body);

      // Check the response status
      if (response.statusCode == 200) {
        // Assuming your API returns a success status in the body
        final responseData = json.decode(response.body);
        if (responseData['success']) { // Change this condition based on your API's response
          return true;  // Login successful
        }
      }
      return false;  // Login failed
    } catch (e) {
      // Handle any exceptions during the login process
      debugPrint('Error during login: $e');
      return false;
    }
  }
}
