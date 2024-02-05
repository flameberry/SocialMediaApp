import 'package:flutter/material.dart';

class FBYTextField extends StatelessWidget {
  final String placeholder;
  final bool obscureText;
  final TextEditingController editingController;

  const FBYTextField(
      {super.key,
      required this.placeholder,
      required this.obscureText,
      required this.editingController});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(40),
      elevation: 6.0,
      shadowColor: Colors.black,
      child: TextField(
        controller: editingController,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: placeholder,
          contentPadding: const EdgeInsets.all(14.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(width: 2.0)),
        ),
      ),
    );
  }
}
