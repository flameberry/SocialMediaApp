import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/fbyuser.dart';
import 'package:social_media_app/model/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String input = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Card(
              child: ListTile(
            leading: const Icon(Icons.search),
            title: TextField(
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
              onChanged: (value) => setState(() {
                input = value;
              }),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => setState(() {
                input = "";
              }),
            ),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder<List<UserModel>>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .snapshots()
                .map((snapshot) {
              return snapshot.docs.map((doc) {
                final userData = doc.data();
                return UserModel(
                  id: doc.id,
                  name: doc['name'],
                  username: doc['username'],
                  email: doc['email'],
                  profileImageUrl: doc['profileImageUrl'],
                  followers: userData['followers'] ?? 0,
                  following: userData['following'] ?? 0,
                );
              }).toList();
            }),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];
                        final name = user.name;
                        final userName = user.username;
                        final userEmail = user.email;
                        if (name
                                .toString()
                                .toLowerCase()
                                .startsWith(input.toLowerCase()) ||
                            userName
                                .toString()
                                .toLowerCase()
                                .startsWith(input.toLowerCase()) ||
                            userEmail
                                .toString()
                                .toLowerCase()
                                .startsWith(input.toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: FBYUser(user: user),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
            },
          ),
        ));
  }
}
