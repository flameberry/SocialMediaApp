import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/src/panel.dart';
import 'package:social_media_app/components/fbypost.dart';
import 'package:social_media_app/model/joke.dart';
import 'package:social_media_app/model/user.dart';
import 'package:social_media_app/components/joke_message.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.message,
    required this.panelController,
    required this.threadId,
  });

  final Joke message;
  final PanelController panelController;
  final String threadId;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CollectionReference threadCollection =
      FirebaseFirestore.instance.collection('Jokes');
  Stream<UserModel> fetchUserData(String id) {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(id).snapshots();
      return userDoc
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Joke',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FBYPost(
                message: widget.message,
                onLike: () {},
                onDisLike: () {},
                onComment: () {},
                panelController: widget.panelController,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  const Text('Comments'),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                stream: threadCollection.doc(widget.threadId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final comments = data['comments'];

                  if (comments == null) {
                    return const Text(
                        'No comments yet. Be the first to comment!');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];

                        DateTime timeStamp = DateTime.now();

                        if (comment.containsKey('time') &&
                            comment['time'] != null) {
                          timeStamp = (comment['time'] as Timestamp).toDate();
                        }
                        return StreamBuilder(
                            stream: fetchUserData(comment['id']),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              final user = snapshot.data!;

                              final message = Joke(
                                id: comment['id'],
                                email: user.email,
                                senderName: user.name,
                                senderProfileImageUrl:
                                    user.profileImageUrl ?? "",
                                message: comment['text'],
                                timestamp: timeStamp,
                                likes: [],
                                comments: [],
                              );

                              return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: FBYPost(
                                  message: message,
                                  onLike: () {},
                                  onDisLike: () {},
                                  onComment: () {},
                                  panelController: widget.panelController,
                                ),
                              );
                            });
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
