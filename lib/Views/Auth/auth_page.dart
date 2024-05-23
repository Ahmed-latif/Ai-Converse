import 'package:ai_converse_chatbot_app/Views/Auth/Login%20Screen/login_screen.dart';
import 'package:ai_converse_chatbot_app/Views/Auth/Sign%20up/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  void toggleScrenn() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(showRegisterPage: toggleScrenn);
    }
    return SignUpScreen(showLoginPage: toggleScrenn);
  }
}
