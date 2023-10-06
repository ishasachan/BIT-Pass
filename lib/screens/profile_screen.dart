import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/token_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String profileImageBase64 = '';
  String roll = '';
  String email = '';
  String department = '';
  String mobile = '';
  String hostel = '';
  String room = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('https://bit-pass-server.onrender.com/api/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          name = userData['name'] ?? '';
          profileImageBase64 = userData['profileImage'] ?? '';
          roll = userData['roll'] ?? '';
          email = userData['email'] ?? '';
          department = userData['department'] ?? '';
          mobile = userData['mobile'] ?? '';
          hostel = userData['hostel'] ?? '';
          room = userData['room'] ?? '';
        });
      } else {
        const errorMessage = 'Failed to fetch user profile.';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      final errorMessage = 'An error occurred: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.brown,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/profile-edit');
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (profileImageBase64 == "")
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                //Display the profile image using Image.memory
                if (profileImageBase64 != "")
                  ClipOval(
                    child: Image.memory(
                      base64Decode(
                          profileImageBase64), // Decode base64 to bytes
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 10),
                _buildProfileInfoRow('Name', name),
                _buildProfileInfoRow('Roll Number', roll),
                _buildProfileInfoRow('Email', email),
                _buildProfileInfoRow('Course', department),
                _buildProfileInfoRow('Mobile Number', mobile),
                _buildProfileInfoRow('Hostel Number', hostel),
                _buildProfileInfoRow('Room Number', room),
                const SizedBox(height: 10),
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data:
                      '$name, $roll, $email, $department, $mobile, $hostel, $room',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
