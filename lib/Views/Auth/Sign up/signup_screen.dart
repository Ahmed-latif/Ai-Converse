import 'package:ai_converse_chatbot_app/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/myTextFormField.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpScreen({super.key, required this.showLoginPage});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPassword.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    }
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() == confirmPassword.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register now to explore our\n AIConverse Chatbot App',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextFormField(
                hintText: 'Email',
                labelText: 'Enter your email',
                obscureText: false,
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).iconTheme.color,
                ),
                myController: emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                labelText: 'Enter your password',
                hintText: 'Password',
                obscureText: false,
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).iconTheme.color,
                ),
                myController: passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                labelText: 'Enter your password to confirm',
                hintText: 'Confirm Password',
                obscureText: true,
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).iconTheme.color,
                ),
                myController: confirmPassword,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: MyButton(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  title: 'Sign up',
                  onPressed: () {
                    signUp();
                  },
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      'Sign in',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
