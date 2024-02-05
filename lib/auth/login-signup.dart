import 'package:flutter/material.dart';
import 'package:social_media_app/pages/login.dart';
import 'package:social_media_app/pages/signup.dart';

class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({super.key});

  @override
  State<LoginOrSignUp> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onClickedOnSignUpHere: togglePages);
    } else {
      return SignUpPage(onClickedOnLoginHere: togglePages);
    }
  }
}
