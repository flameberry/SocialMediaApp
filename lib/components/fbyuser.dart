import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/model/user.dart';

class FBYUser extends StatelessWidget {
  FBYUser({super.key, required this.user});

  final UserModel user;

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile', arguments: {
          'targetUserEmail': user.email,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 2),
        ),
        padding: const EdgeInsets.all(0.0),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 6.0,
          shadowColor: Colors.black,
          child: ListTile(
            visualDensity: VisualDensity.compact,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl ??
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz8cLf8-P2P8GZ0-KiQ-OXpZQ4bebpa3K3Dw&usqp=CAU"),
              backgroundColor: Colors.white,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "@${user.username}",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
