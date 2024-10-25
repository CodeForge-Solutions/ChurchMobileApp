import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Login/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace with your home page
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/animation/animatedLottie.json'),
      ),
    );
  }
}
