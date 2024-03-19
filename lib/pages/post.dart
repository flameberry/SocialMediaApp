import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/src/panel.dart';
import 'package:social_media_app/model/user.dart';
import 'package:http/http.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
    required this.panelController,
  });

  final PanelController panelController;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final messageController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser;
  late Future<UserModel> fetchUser;

  List<dynamic> suggestedJokes = [];

  Future<void> postThreadMessage(String username) async {
    try {
      if (messageController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('Jokes').add({
          'id': currentUser!.uid,
          'email': currentUser!.email,
          'sender': username,
          'message': messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        messageController.clear();
        widget.panelController.close();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .get();
      final user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  void fetchJokes() async {
    // const url = 'https://us-central1-social-media-app-6b0e7.cloudfunctions.net/getJokes';
    const url = 'https://icanhazdadjoke.com/search?limit=5';
    final response = await get(Uri.parse(url));
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      suggestedJokes = json['results'] as List;
    });
  }

  @override
  void initState() {
    fetchUser = fetchUserData();
    // fetchJokes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<UserModel>(
          future: fetchUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final user = snapshot.data;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.panelController.close();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        'New thread',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      TextButton(
                        onPressed: () => postThreadMessage(user?.name ?? ""),
                        child: const Text(
                          'Post',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                NetworkImage(user?.profileImageUrl ?? ""),
                            radius: 25,
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  user?.username ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                    hintText: 'Start a Joke thread...',
                                    hintStyle: TextStyle(fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
