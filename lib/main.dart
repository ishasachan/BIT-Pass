import 'package:bitpass/screens/home_screen.dart';
import 'package:bitpass/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:bitpass/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userToken = prefs.getString('user_token');

  runApp(BITPassApp(userToken));
}

class BITPassApp extends StatelessWidget {
  final String? userToken;

  const BITPassApp(this.userToken, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: userToken != null ? const HomeScreen() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      title: 'BITPass',
      initialRoute: userToken != null ? '/home' : '/onboarding',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
