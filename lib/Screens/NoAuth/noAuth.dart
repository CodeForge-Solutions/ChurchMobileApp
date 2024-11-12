import 'package:flutter/material.dart';
import '../../constants.dart';
import '../Login/login.dart';

class NoAuthPage extends StatelessWidget {
  const NoAuthPage({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Center Image
              Image.asset(
                'assets/images/no_auth.jpg', // Your image here
                height: 400,
                width: 400,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: kSpacing * 2),

              // Informative Text
              const Text(
                "Please wait until admin allow access to application.",
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
            ],
          ),
        ),
      ),
    );
  }
}
