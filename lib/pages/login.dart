import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:social_media_app/helper/helpers.dart';
import '../components/textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onClickedOnSignUpHere;

  const LoginPage({super.key, required this.onClickedOnSignUpHere});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  void loginUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser("Failed to login firebase user: $e.code", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flameberry Logo
              Image.asset(
                "assets/images/logo.png",
                scale: 1.8,
              ),
              // Flameberry Text
              const Text(
                "Flameberry | Login",
                style: TextStyle(fontFamily: "Imperial Script", fontSize: 52),
              ),

              const SizedBox(height: 10.0),

              // Email Text Field
              FBYTextField(
                  placeholder: "Email",
                  obscureText: false,
                  editingController: emailController),

              const SizedBox(height: 20.0),

              // Password Text Field
              FBYTextField(
                  placeholder: "Password",
                  obscureText: true,
                  editingController: passwordController),

              const SizedBox(height: 20.0),

              const Text(
                "Forgot Password?",
                style: TextStyle(decoration: TextDecoration.underline),
              ),

              const SizedBox(height: 20.0),

              // Login Button
              Material(
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black,
                elevation: 6,
                child: GestureDetector(
                  onTap: loginUser,
                  child: Container(
                    width: 175,
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                ),
              ),

              const SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    onTap: widget.onClickedOnSignUpHere,
                    child: const Text(
                      " Sign Up here.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sign In With Google Button
              Material(
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black,
                elevation: 6,
                child: GestureDetector(
                  onTap: () => {print("Pressed button!")},
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.lightGreenAccent.shade700, width: 4.0),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google Icon
                          Image.asset(
                            "assets/images/google.png",
                            width: 36,
                            height: 36,
                          ),

                          const SizedBox(width: 10.0),

                          // Text
                          const Center(
                              child: Text(
                            "Sign up with Google",
                            style: TextStyle(fontSize: 20),
                          )),
                        ]),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign In With Apple ID button
              Material(
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black,
                elevation: 6,
                child: GestureDetector(
                  onTap: () => {print("Pressed button!")},
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: const GradientBoxBorder(
                        width: 4.0,
                        gradient: LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.indigo,
                            Colors.purple,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Apple Icon
                          Icon(
                            Icons.apple,
                            size: 40,
                          ),

                          SizedBox(width: 10.0),

                          // Text
                          Center(
                              child: Text(
                            "Sign up with Apple ID",
                            style: TextStyle(fontSize: 20),
                          )),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
