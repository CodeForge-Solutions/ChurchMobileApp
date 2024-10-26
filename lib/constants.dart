import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Primary Colors
const Color kPrimaryColor = Color(0xFF6F35A5);
const Color kPrimaryLightColor = Color(0xFFF1E6FF);
const Color kAccentColor = Color(0xFF4CAF50); // Example of another color
const Color kErrorColor = Color(0xFFFF0000); // Error color

// Gradient Colors
const Color gradientStartColor = Colors.deepPurple;
const Color gradientEndColor = Colors.purpleAccent;

// Padding & Spacing
const double defaultPadding = 16.0;
const double kCardMargin = 5.0;
const double kCardPadding = 15.0;
const double kDetailPadding = 16.0;
const double kSpacing = 10.0;

// Font Sizes
const double kAppBarFontSize = 20.0;
const double kUserNameFontSize = 18.0;
const double kDetailNameFontSize = 24.0;
const double kDetailPhoneFontSize = 18.0;

// Toast settings
const int kToastDuration = 3; // Duration in seconds
const int kButtonDisableDuration = 2; // Duration in seconds to disable button

// Border Radius
const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8.0));

// API Configuration
const String baseUrl = 'https://localhost:5064/api/';

// Text Styles
const TextStyle signUpTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24.0,
);

// Input Decoration - Custom Styling for TextFields
InputDecoration customInputDecoration(String hintText,[IconData? icon]) {
  return InputDecoration(
    labelText: hintText,
    labelStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
    prefixIcon: icon != null ? Icon(icon) : null,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Regular border
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: kPrimaryColor, width: 1.0), // Focused border
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.red, width: 1.0), // Error border
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.red, width: 1.5), // Focused error border
    ),
  );
}

// Gradient Button Styling
Widget buildGradientButton({
  required Widget child,
  required VoidCallback onPressed,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [gradientStartColor, gradientEndColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: child,
    ),
  );
}

// Toast Message Helper with Custom Styling
void showToast(BuildContext context,String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: kPrimaryColor, // Use your primary color for the background
    textColor: Colors.white,
    fontSize: 16.0,
    webBgColor: "linear-gradient(to right, #6F35A5, #F1E6FF)", // Example for web
    webPosition: "right", // Position for web (optional)
  );
}


// Loading Indicator Widget
Widget buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
    ),
  );
}

// Empty State Widget
Widget buildEmptyState({required String message}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey, fontSize: kUserNameFontSize),
        textAlign: TextAlign.center,
      ),
    ),
  );
}


