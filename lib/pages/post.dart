import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/src/panel.dart';
import 'package:social_media_app/model/user.dart';
import 'package:http/http.dart' as http;

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

  late Future<List<String>> suggestedJokes;

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

  Future<List<String>> fetchJokesUsingAPI() async {
    final response = await http
        .get(Uri.parse('https://official-joke-api.appspot.com/random_ten'));

    if (response.statusCode == 200) {
      List jokes = json.decode(response.body);
      return jokes
          .take(5)
          .map((joke) => "${joke['setup']} - ${joke['punchline']}")
          .toList();
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  @override
  void initState() {
    fetchUser = fetchUserData();
    suggestedJokes = fetchJokesUsingAPI();
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
                      FutureBuilder<List<String>>(
                        future: suggestedJokes,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return ListView.builder(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap:
                                  true, // this is needed to make ListView work inside a Column
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    messageController.text =
                                        snapshot.data![index];
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data![index],
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      const Text("Joke Suggestions",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
