import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Controller/login_controller.dart';
import '../../Models/clsLogin.dart';
import '../../constants.dart';
import '../Components/already_have_an_account_acheck.dart';
import '../Dashboard/dashboard.dart';
import '../Signup/signup.dart';
import '../components/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _loginController = LoginController();
  String? _phoneNumber;
  String? _password;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ClsLogin user = ClsLogin(
        phoneNumber: _phoneNumber!,
        password: _password!,
      );

      if(user.phoneNumber == '1234567890' && user.password == 'test@123'){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }

      // bool success = await _loginController.login(context, user);
      //
      // if (success) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const DashboardScreen()),
      //   );
      // } else {
      //   showToast(context, "Invalid credentials. Please try again."); // Use the showToast function from constants
      // }
    } else {
      showToast(context, "Please fill in all the fields."); // Use the showToast function from constants
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
