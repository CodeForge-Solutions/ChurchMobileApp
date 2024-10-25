import 'package:flutter/material.dart';
import '../../constants.dart'; // Import your constants file

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      showToast(context, 'Password changed successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: kAppBarFontSize),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Center Image
              Image.asset(
                'assets/images/change_password.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: kSpacing * 2),

              // Old Password Field
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: customInputDecoration("Old Password", Icons.lock),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your old password' : null,
              ),
              const SizedBox(height: kSpacing),

              // New Password Field
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: customInputDecoration("New Password", Icons.lock_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a new password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kSpacing),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: customInputDecoration("Confirm Password", Icons.lock_reset),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your new password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kSpacing * 3),

              // Submit Button with Gradient
              buildGradientButton(
                onPressed: _changePassword,
                child: const Text(
                  "Change Password",
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
