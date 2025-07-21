import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isObscureCurrent = true;
  bool isObscureNew = true;
  bool isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 30, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Change Password',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 35),
                    _buildPasswordField(
                      label: 'Current Password',
                      controller: currentPasswordController,
                      obscureText: isObscureCurrent,
                      toggleVisibility: () =>
                          setState(() => isObscureCurrent = !isObscureCurrent),
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please enter your current password'
                          : null,
                    ),

                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: 'New Password',
                      controller: newPasswordController,
                      obscureText: isObscureNew,
                      toggleVisibility: () =>
                          setState(() => isObscureNew = !isObscureNew),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter a new password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        if (value == currentPasswordController.text)
                          return 'New password must be different';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      obscureText: isObscureConfirm,
                      toggleVisibility: () =>
                          setState(() => isObscureConfirm = !isObscureConfirm),
                      validator: (value) =>
                      value != newPasswordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                  ],
                )


              ),


              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password changed successfully')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3C95E),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                      'Submit', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator,
    );
  }
}
