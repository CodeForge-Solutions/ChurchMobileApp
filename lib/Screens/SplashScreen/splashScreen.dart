import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../Models/clsLogin.dart';
import '../../constants.dart';
import '../../shared_preference.dart';
import '../Dashboard/dashboard.dart';
import '../Login/login.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the Animation Controller without duration
    _controller = AnimationController(vsync: this);
    _initializeApp();
  }

  // Function to handle the login process
  Future<bool> splashLogin({String? phoneNumber, String? password}) async {
    const String apiUrl = '${baseUrl}auth/login'; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userDetails = responseData["data"]["user"];

        // Clear any existing preferences and store new user data
        await SharedPrefs.clear();
        await SharedPrefs.setString(SharedPrefs.name, userDetails["name"]);
        await SharedPrefs.setString(SharedPrefs.phoneNumber, userDetails["phoneNumber"]);
        await SharedPrefs.setString(SharedPrefs.userPass, userDetails["password"]);
        await SharedPrefs.setInt(SharedPrefs.userId, userDetails["mstUserId"]);
        await SharedPrefs.setInt(SharedPrefs.userAccessLevel, userDetails["userAccessLevel"]);
        await SharedPrefs.setString(SharedPrefs.token, responseData["data"]["token"]);

        return true; // Login successful
      } else {
        final errorData = jsonDecode(response.body);
        showToast(context, errorData['message']);
        return false; // Login failed
      }
    } catch (e) {
      showToast(context, "An error occurred. Please try again.");
      return false; // Handle exception
    }
  }

  // Initialize the app and handle navigation logic
  Future<void> _initializeApp() async {
    // Check for stored credentials
    String? phoneNumber = SharedPrefs.getString(SharedPrefs.phoneNumber);
    String? password = SharedPrefs.getString(SharedPrefs.userPass);

    await Future.delayed(const Duration(seconds: 3));

    if (phoneNumber != null && password != null) {
      // If credentials exist, attempt to log in automatically
      bool success = await splashLogin(phoneNumber: phoneNumber, password: password);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // No stored credentials, navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animation/animatedLottie.json', // Ensure this path is correct
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward(); // Start animation only after the duration is set
          },
        ),
      ),
    );
  }
}
