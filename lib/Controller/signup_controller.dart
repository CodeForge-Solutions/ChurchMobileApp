import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For toast notifications
import '../Models/clsSignUp.dart'; // Import your ClsSignUp model
import 'api_service.dart';
import '../../constants.dart'; // Import constants if needed

class SignUpController {
  final ApiService _apiService = ApiService(); // Instance of ApiService

  // Signup function using ClsSignUp model
  Future<bool> signUp(BuildContext context, ClsSignUp user) async {
    try {
      // Create request body from ClsSignUp model
      final body = {
        'name': user.name,
        'dateOfBirth': user.dateOfBirth, // Ensure date is in the correct format
        'gender': user.gender,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
        'password': user.password,
      };

      // Call the API and await response
      final response = await _apiService.apiCall(
        'signup', // Change the endpoint to your actual signup endpoint
        method: 'POST',
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {  // Check API response success status
          showToast(context, 'Signup successful!');  // Display success toast
          return true;
        } else {
          showToast(context, responseData['message']); // Display error message from API
        }
      } else {
        showToast(context, 'Error: ${response.statusCode}'); // Handle non-200 responses
      }
      return false; // Return false if signup failed
    } catch (e) {
      // Handle exceptions during signup
      debugPrint('Error during signup: $e');
      showToast(context, 'An error occurred. Please try again.'); // Show generic error
      return false;
    }
  }

  // Function to show toast messages
  void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: kPrimaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
