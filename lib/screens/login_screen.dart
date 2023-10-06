import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_button.dart';
import '../services/token_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleLogin(
      BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://bit-pass-server.onrender.com/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the token from the response
        final String? token = responseData['token'];

        if (token != null) {
          // Save the token using TokenManager
          await TokenManager.saveToken(token);
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token not found in response.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle error response from the server
        final Map<String, dynamic> errorData = json.decode(response.body);
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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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

            // Password input field
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 20.0),

            // Login button
            CustomButton(
              text: "Login",
              onPressed: () {
                final userEmail = emailController.text;
                final userPassword = passwordController.text;
                _handleLogin(context, userEmail, userPassword);
              },
            ),

            // Sign-up link
            TextButton(
              onPressed: () {
                // Navigate to the signup screen
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
