import 'package:church_mobile_app/Screens/Components/background.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants.dart'; // Ensure constants are imported
import '../../responsive.dart';
import '../Components/already_have_an_account_acheck.dart';
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
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _dobController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dobController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyboard, // Hide keyboard on outside tap
      child: SingleChildScrollView(
        controller: _scrollController,
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
                    _buildTextFormField(
                      label: "Your Name",
                      icon: Icons.person,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    _buildDateOfBirthField(context),
                    const SizedBox(height: defaultPadding),
                    _buildGenderDropdown(),
                    const SizedBox(height: defaultPadding),
                    _buildTextFormField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      inputType: TextInputType.phone,
                      validator: (value) =>
                      value == null || value.length != 10
                          ? 'Enter a valid phone number'
                          : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    _buildTextFormField(
                      label: "Email",
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      validator: (value) =>
                      value == null || !value.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    _buildPasswordField(),
                    const SizedBox(height: defaultPadding),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: defaultPadding),
                    _buildSignUpButton(context),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.number,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: customInputDecoration(label, icon),
      validator: validator,
      onTap: _hideKeyboard,
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: customInputDecoration("Date of Birth", Icons.calendar_today),
      onTap: () async {
        await _selectDate(context);
        _hideKeyboard();
      },
      validator: (value) =>
      value == null || value.isEmpty ? 'Select your date of birth' : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: customInputDecoration("Select Gender", Icons.person_outline),
      items: const [
        DropdownMenuItem(value: 'M', child: Text('Male')),
        DropdownMenuItem(value: 'F', child: Text('Female')),
      ],
      validator: (value) => value == null ? 'Please select gender.' : null,
      onChanged: (_) {},
      buttonStyleData:
      const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
      iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.black45)),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: customInputDecoration("Password", Icons.lock),
      validator: (value) =>
      value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
      onTap: _hideKeyboard,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: customInputDecoration("Confirm Password", Icons.lock),
      validator: (value) =>
      value != _passwordController.text ? 'Passwords do not match' : null,
      onTap: _hideKeyboard,
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
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
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else {
            showToast(context, "Please fill in all required fields.");
          }
        },
        child: Text("Sign Up".toUpperCase(),
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
