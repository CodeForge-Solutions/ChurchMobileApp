import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import '../../constants.dart';
import '../Login/login.dart';

class RequestRejectedPage extends StatelessWidget {
  const RequestRejectedPage({Key? key}) : super(key: key);

  // Function to handle Logout action
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  // Function to handle Request Again action
  Future<void> _requestAgain(BuildContext context, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/request-again'), // Replace with your API URL
        body: {
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        // Handle successful response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request sent successfully")),
        );
      } else {
        // Handle failure response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send request")),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error sending request")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userId = "yourUserId"; // Replace with actual user ID

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Center Image
              Image.asset('assets/images/no_auth.jpg',
                height: 400,
                width: 400,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: kSpacing * 2),

              // Informative Text
              const Text(
                "Your access request was rejected. You can request access again.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kSpacing * 2),

              // Logout Button with Gradient
              buildGradientButton(
                onPressed: () => _logout(context),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: kSpacing),

              // Request Again Button with Gradient
              buildGradientButton(
                onPressed: () => _requestAgain(context, userId),
                child: const Text(
                  "Request Again",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
