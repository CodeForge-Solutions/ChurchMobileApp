import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../responsive.dart';
import '../Components/already_have_an_account_acheck.dart';
import '../Components/background.dart';
import '../Dashboard/dashboard.dart';
import '../Login/login.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignUpScreen(),
        ),
      ),
    );
  }
}

class MobileSignUpScreen extends StatefulWidget {
  const MobileSignUpScreen({Key? key}) : super(key: key);

  @override
  State<MobileSignUpScreen> createState() => _MobileSignUpScreenState();
}

class _MobileSignUpScreenState extends State<MobileSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;
  final String apiUrl = "${baseUrl}auth/userRegister";

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final requestBody = jsonEncode({
      "name": _nameController.text,
      "dateOfBirth": _dobController.text,
      "gender": _selectedGender,
      "phoneNumber": _phoneController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['isSuccess'] == true) {
        showToast(context,"Wait For Some Time To Accepted By Admin!!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        showToast(context, responseData['message']);
      }
    } catch (error) {
      showToast(context, "Something went wrong. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: defaultPadding),
              const Text("SIGN UP", style: signUpTitleStyle),
              const SizedBox(height: defaultPadding),
              Image.asset("assets/images/signup_top_image.jpg", height: 150),
              const SizedBox(height: defaultPadding),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: customInputDecoration("Your Name", Icons.person),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: customInputDecoration("Date of Birth", Icons.calendar_today),
                      onTap: () => _selectDate(context),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Select your date of birth' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: customInputDecoration("Select Gender", Icons.person_outline),
                      items: const [
                        DropdownMenuItem(value: 'M', child: Text('Male')),
                        DropdownMenuItem(value: 'F', child: Text('Female')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please select gender.' : null,
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: customInputDecoration("Phone Number", Icons.phone),
                      validator: (value) =>
                      value == null || value.length != 10 ? 'Enter a valid phone number' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: customInputDecoration("Email", Icons.email),
                      validator: (value) =>
                      value == null || !value.contains('@') ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: customInputDecoration("Password", Icons.lock),
                      validator: (value) =>
                      value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      obscureText: true,
                      decoration: customInputDecoration("Confirm Password", Icons.lock),
                      validator: (value) =>
                      value != _passwordController.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    buildGradientButton( // Use the buildGradientButton function from constants
                      onPressed: _registerUser,
                      child: Text(
                        "Sign Up".toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
