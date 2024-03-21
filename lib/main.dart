import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app/auth/auth.dart';
import 'package:social_media_app/auth/login-signup.dart';
import 'package:social_media_app/pages/home.dart';
import 'package:social_media_app/pages/profile.dart';
import 'firebase_options.dart';
import 'theme/light.dart';
import 'theme/dark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
      routes: {
        '/login_signup': (context) => const LoginOrSignUp(),
        '/home': (context) => const Home(),
        '/profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ProfilePage(targetUserEmail: args['targetUserEmail']);
        },
      },
    );
  }
}
