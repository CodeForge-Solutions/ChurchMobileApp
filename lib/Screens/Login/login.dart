import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Models/clsLogin.dart';
import '../../constants.dart';
import '../../shared_preference.dart';
import '../Components/already_have_an_account_acheck.dart';
import '../Dashboard/dashboard.dart';
import '../Signup/singup.dart';
import '../components/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  String? _password;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ClsLogin user = ClsLogin(
        phoneNumber: _phoneNumber!,
        password: _password!,
      );

      // Call the API for login
      final bool success = await login(user);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    }
  }

  Future<bool> login(ClsLogin user) async {
    const String apiUrl = '${baseUrl}auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': user.phoneNumber,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final responseBody = responseData["data"];
        final userDetails = responseBody["user"];

        await SharedPrefs.clear();

        await SharedPrefs.setString(SharedPrefs.name,userDetails["name"]);
        await SharedPrefs.setString(SharedPrefs.phoneNumber, userDetails["phoneNumber"]);
        await SharedPrefs.setString(SharedPrefs.userPass, userDetails["password"]);
        await SharedPrefs.setInt(SharedPrefs.userId, userDetails["mstUserId"]);
        await SharedPrefs.setString(SharedPrefs.token, responseBody["token"]);
        await SharedPrefs.setInt(SharedPrefs.userAccessLevel, userDetails["userAccessLevel"]);

        return true;
      } else {
        // Handle login failure
        final errorData = jsonDecode(response.body);
        showToast(context, errorData['message']);
        return false;
      }
    } catch (e) {
      showToast(context, "An error occurred. Please try again.");
      return false;
    }
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "LOGIN",
                  style: signUpTitleStyle,
                ),
                const SizedBox(height: defaultPadding * 2),
                Image.asset('assets/images/login_top_image.png'),
                const SizedBox(height: defaultPadding * 2),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onSaved: (value) => _phoneNumber = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                          decoration: customInputDecoration(
                            "Phone Number",
                            Icons.phone,
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          cursorColor: kPrimaryColor,
                          onSaved: (value) => _password = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: customInputDecoration(
                            "Password",
                            Icons.lock,
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        buildGradientButton( // Use the buildGradientButton function from constants
                          onPressed: _login,
                          child: Text(
                            "Login".toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        AlreadyHaveAnAccountCheck(
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
