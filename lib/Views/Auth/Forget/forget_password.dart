import 'package:ai_converse_chatbot_app/components/myTextFormField.dart';
import 'package:ai_converse_chatbot_app/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Reset email has been sent')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for that email')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              Text(
                'Password Recovery',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Enter your email',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                  icon: Icon(
                    Icons.email,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  obscureText: false,
                  myController: emailController),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: MyButton(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    title: 'Send Code',
                    onPressed: () {
                      passwordReset();
                    }),
              )
            ],
          )),
        ),
      ),
    );
  }
}
