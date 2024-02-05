import 'package:flutter/material.dart';
import 'package:social_media_app/auth/login-signup.dart';
import 'theme/light.dart';
import 'theme/dark.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const LoginOrSignUp(),
    );
  }
}
