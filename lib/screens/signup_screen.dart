import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  bool showOtpField = false;

  Future<void> _handleSignup(
      BuildContext context, String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('https://bit-pass-server.onrender.com/api/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          showOtpField = true;
        });
      } else {
        // Handle error response from the server
        final Map<String, dynamic> errorData = json.decode(response.body);
        debugPrint(response.body);
        final errorMessage = errorData['message'] ?? 'An error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      debugPrint('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleOtpSubmit(
      BuildContext context, String email, String otp) async {
    try {
      final response = await http.put(
        Uri.parse('https://bit-pass-server.onrender.com/api/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful OTP verification, e.g., navigate to the home screen
        Navigator.pushNamed(context, '/complete-profile');
      } else {
        // Handle error response from the server
        final Map<String, dynamic> errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'An error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAD3C8),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your logo or app branding here
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 150,
            ),

            const SizedBox(height: 20.0),

            // Email input field
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20.0),

            // OTP input field (conditionally displayed)
            if (showOtpField)
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 20.0),

            // Sign-up button
            CustomButton(
              text: showOtpField ? "Verify OTP" : "Sign Up",
              onPressed: () {
                final userEmail = emailController.text;
                final userOtp = otpController.text;

                if (showOtpField) {
                  // If OTP field is shown, handle OTP verification
                  _handleOtpSubmit(context, userEmail, userOtp);
                } else {
                  // Otherwise, handle initial sign-up request
                  _handleSignup(context, userEmail, userOtp);
                }
              },
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Already have an account? Log In',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
