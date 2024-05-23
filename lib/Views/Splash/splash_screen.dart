import 'package:ai_converse_chatbot_app/Views/Auth/auth_page.dart';
import 'package:ai_converse_chatbot_app/Views/Bottom%20Navigation%20Bar/bottom_nav.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _goHome();
    // TODO: implement initState
    super.initState();
  }

  _goHome() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // Handle different connection states
                if (snapshot.hasData) {
                  // Determine appropriate content based on user state
                  return const MyBottomNavBar();
                } else {
                  return const AuthPage();
                }
              },
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/slpash screen.png',
              height: 200,
            ),
            SizedBox(
              height: 10,
            ),
            AnimatedTextKit(repeatForever: true, animatedTexts: [
              FlickerAnimatedText('AIConverse Chatbot App',
                  textStyle: Theme.of(context).textTheme.headlineLarge),

              // (
              //   'AIConverse Chatbot App',
              //   textStyle: Theme.of(context).textTheme.headlineLarge,
              // )
            ]),
          ],
        ),
      ),
    );
  }
}
