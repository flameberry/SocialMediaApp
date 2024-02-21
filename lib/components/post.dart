import 'package:flutter/material.dart';

class FBYPost extends StatelessWidget {
  const FBYPost({super.key, required this.username, required this.content});

  final String username, content;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          leading: const Icon(Icons.person),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Text(
                    "7hr ago",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: "Inter",
                  height: 1.2,
                ),
              ),
            ],
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(Icons.favorite),
                SizedBox(width: 10),
                Icon(Icons.comment),
                SizedBox(width: 10),
                Icon(Icons.recycling)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
