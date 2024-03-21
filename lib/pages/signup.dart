import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:social_media_app/helper/helpers.dart';
import '../components/textfield.dart';

class SignUpPage extends StatefulWidget {
  final void Function()? onClickedOnLoginHere;

  const SignUpPage({super.key, required this.onClickedOnLoginHere});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController(),
      usernameController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController();

  void signUpUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayMessageToUser(
          "Password and Confirm Password must be the same!", context);
    } else {
      try {
        // Create the user
        UserCredential? credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        createUserDocument(credential);

        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(
            "Failed to create firebase user: $e.code", context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'id': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'name': nameController.text,
        'username': usernameController.text,
        'role': 'Normal',
        'following': [],
        'followers': []
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flameberry Logo
                Image.asset(
                  "assets/images/logo.png",
                  scale: 2,
                ),
                // Flameberry Text
                const Text(
                  "Flameberry | Sign Up",
                  style: TextStyle(fontFamily: "Imperial Script", fontSize: 40),
                ),

                const SizedBox(height: 10.0),

                FBYTextField(
                  placeholder: "Full Name",
                  obscureText: false,
                  editingController: nameController,
                ),

                const SizedBox(height: 10.0),

                FBYTextField(
                  placeholder: "Username",
                  obscureText: false,
                  editingController: usernameController,
                ),

                const SizedBox(height: 10.0),

                // Email Text Field
                FBYTextField(
                  placeholder: "Email",
                  obscureText: false,
                  editingController: emailController,
                ),

                const SizedBox(height: 10.0),

                FBYTextField(
                  placeholder: "Password",
                  obscureText: true,
                  editingController: passwordController,
                ),

                const SizedBox(height: 10.0),

                // Password Text Field
                FBYTextField(
                    placeholder: "Confirm Password",
                    obscureText: true,
                    editingController: confirmPasswordController),

                const SizedBox(height: 10.0),

                // Login Button
                Material(
                  borderRadius: BorderRadius.circular(30),
                  shadowColor: Colors.black,
                  elevation: 6,
                  child: GestureDetector(
                    onTap: signUpUser,
                    child: Container(
                      width: 175,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20),
                      )),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: widget.onClickedOnLoginHere,
                      child: const Text(
                        " Login here.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

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
                            color: Colors.lightGreenAccent.shade700,
                            width: 4.0),
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
      ),
    );
  }
}
