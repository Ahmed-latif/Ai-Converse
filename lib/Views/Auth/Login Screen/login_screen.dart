import 'package:ai_converse_chatbot_app/Views/Auth/Forget/forget_password.dart';
import 'package:ai_converse_chatbot_app/components/divider.dart';
import 'package:ai_converse_chatbot_app/components/google_button.dart';
import 'package:ai_converse_chatbot_app/components/myTextFormField.dart';
import 'package:ai_converse_chatbot_app/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginScreen({super.key, required this.showRegisterPage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future _signin() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Please Sign in to explore our\n AIConverse Chatbot App',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextFormField(
                  labelText: 'Enter your email',
                  hintText: 'Email',
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
                  obscureText: true,
                  icon: Icon(
                    Icons.lock,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  myController: passwordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MyButton(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    title: 'Sign in',
                    onPressed: () {
                      _signin();
                    },
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPassword()));
                          },
                          child: Text(
                            'Froget Password?',
                            style: Theme.of(context).textTheme.titleSmall,
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an Account?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text(
                        'Sign Up Now',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DividerLine(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: GoogleButton(
                        title: 'Sign in with Google',
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        onPressed: () {
                          signInWithGoogle();
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
