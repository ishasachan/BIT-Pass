import 'package:bitpass/screens/complete_profile_screen.dart';
import 'package:bitpass/screens/entry_screen.dart';
import 'package:bitpass/screens/exit_screen.dart';
import 'package:bitpass/screens/home_screen.dart';
import 'package:bitpass/screens/login_screen.dart';
import 'package:bitpass/screens/onboarding_screen.dart';
import 'package:bitpass/screens/profile_edit_screen.dart';
import 'package:bitpass/screens/profile_screen.dart';
import 'package:bitpass/screens/signup_screen.dart';
import 'package:flutter/material.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/complete-profile':
        return MaterialPageRoute(builder: (_) => const CompleteProfileScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/profile-edit':
        return MaterialPageRoute(builder: (_) => const ProfileEditPage());
      case '/entry':
        return MaterialPageRoute(builder: (_) => const EntryScreen());
      case '/exit':
        return MaterialPageRoute(builder: (_) => const ExitScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found!'),
            ),
          ),
        );
    }
  }
}
