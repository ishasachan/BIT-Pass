import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'
    if (dart.library.html) 'package:image_picker_for_web/image_picker_for_web.dart';

import '../widgets/custom_button.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  CompleteProfileScreenState createState() => CompleteProfileScreenState();
}

class CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _imageBase64;

  Future<void> _handleImagePick(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _image = image;
        _imageBase64 = base64String;
      });
    }
  }

  Future<void> _handleCompleteProfile(
      BuildContext context,
      String name,
      String mobile,
      String department,
      String roll,
      String room,
      String hostel,
      String password) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://bit-pass-server.onrender.com/api/auth/complete'), // Replace with your API endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": "btech60137.20@bitmesra.ac.in",
          'name': name,
          'mobile': mobile,
          'department': department,
          'roll': roll,
          "room": room,
          "hostel": hostel,
          'password': password,
          'profileImage': _imageBase64,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful profile completion, e.g., navigate to the home screen

        Navigator.pushNamed(context, '/home');
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
    final nameController = TextEditingController();
    final mobileController = TextEditingController();
    final departmentController = TextEditingController();
    final rollController = TextEditingController();
    final roomController = TextEditingController();
    final hostelController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: const Color(0xffDAD3C8),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Profile image
              GestureDetector(
                onTap: () {
                  _handleImagePick(context); // Handle image picking
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path))
                      : const AssetImage("assets/images/profile.png")
                          as ImageProvider,
                ),
              ),

              const SizedBox(height: 20),
              // Name input field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

              // Mobile input field
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

              // Department input field
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

// Roll input field
              TextFormField(
                controller: rollController,
                decoration: const InputDecoration(
                  labelText: 'Roll Number',
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

// Roll input field
              TextFormField(
                controller: hostelController,
                decoration: const InputDecoration(
                  labelText: 'Hostel Number',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

// Roll input field
              TextFormField(
                controller: roomController,
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  prefixIcon: Icon(Icons.meeting_room),
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

              // Complete profile button
              CustomButton(
                text: "Complete Profile",
                onPressed: () {
                  final userName = nameController.text;
                  final userMobile = mobileController.text;
                  final userDepartment = departmentController.text;
                  final userRoll = rollController.text;
                  final userRoom = roomController.text;
                  final userHostel = hostelController.text;
                  final userPassword = passwordController.text;
                  _handleCompleteProfile(
                      context,
                      userName,
                      userMobile,
                      userDepartment,
                      userRoll,
                      userRoom,
                      userHostel,
                      userPassword);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
