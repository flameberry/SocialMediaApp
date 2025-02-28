import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social_media_app/components/fbypost.dart';
import 'package:social_media_app/model/joke.dart';
import 'package:social_media_app/model/user.dart';
import 'package:social_media_app/pages/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.targetUserEmail});

  final String? targetUserEmail;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late Stream<UserModel> userStream;
  final CollectionReference threadCollection =
      FirebaseFirestore.instance.collection('Jokes');
  PanelController panelController = PanelController();

  bool isCurrentUser = false;
  bool isPanelOpen = false;

  Stream<UserModel> fetchUserData() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.targetUserEmail!)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>));
  }

  Stream<List<Joke>> fetchUserThreads(UserModel user) {
    return FirebaseFirestore.instance
        .collection('Jokes')
        .where('sender', isEqualTo: user.name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final messageData = doc.data();
        final timestamp = (messageData['timestamp'] as Timestamp).toDate();
        return Joke(
          id: doc.id,
          email: messageData['email'],
          senderName: messageData['sender'],
          senderProfileImageUrl: user.profileImageUrl ??
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz8cLf8-P2P8GZ0-KiQ-OXpZQ4bebpa3K3Dw&usqp=CAU',
          message: messageData['message'],
          timestamp: timestamp,
          likes: messageData['likes'] ?? [],
          comments: messageData['comments'] ?? [],
        );
      }).toList();
    });
  }

  @override
  void initState() {
    isCurrentUser =
        FirebaseAuth.instance.currentUser!.email == widget.targetUserEmail!;
    userStream = fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SlidingUpPanel(
          controller: panelController,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          panelBuilder: (ScrollController sc) {
            return StreamBuilder<UserModel>(
              stream: userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final UserModel? user = snapshot.data;
                  if (user != null) {
                    return EditProfile(
                        panelController: panelController, user: user);
                  } else {
                    return const Center(
                      child: Text("No user"),
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: StreamBuilder<UserModel>(
                stream: userStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final UserModel? user = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text(user?.name ?? ""),
                              const SizedBox(
                                width: 10,
                              ),
                              user!.role == "Premium"
                                  ? const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                    )
                                  : Container(),
                            ],
                          ),
                          subtitle: Text('@${user.username ?? ""}'),
                          contentPadding: const EdgeInsets.all(0),
                          trailing: user.profileImageUrl != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profileImageUrl ?? ""),
                                  radius: 25,
                                )
                              : const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz8cLf8-P2P8GZ0-KiQ-OXpZQ4bebpa3K3Dw&usqp=CAU',
                                  ),
                                  radius: 25,
                                ),
                        ),
                        Text(user?.bio ?? 'Bio needs to be here...'),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: [
                              Text(
                                '${user!.followers.length.toString()} followers',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${user.following.length.toString()} following',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: displayButtons(),
                        ),
                        const SizedBox(height: 25),
                        const TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(text: 'Jokes'),
                            Tab(text: 'Replies'),
                            Tab(text: 'Reposts'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              StreamBuilder(
                                stream: fetchUserThreads(user),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final userThread = snapshot.data;
                                    return ListView.builder(
                                      itemCount: userThread!.length,
                                      itemBuilder: (context, index) {
                                        final messageData = userThread[index];
                                        final message = Joke(
                                            id: messageData.id,
                                            email: messageData.email,
                                            senderName: messageData.senderName,
                                            senderProfileImageUrl: user
                                                    .profileImageUrl ??
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz8cLf8-P2P8GZ0-KiQ-OXpZQ4bebpa3K3Dw&usqp=CAU',
                                            message: messageData.message,
                                            timestamp: messageData.timestamp,
                                            likes: messageData.likes,
                                            comments: messageData.comments);
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: FBYPost(
                                            message: message,
                                            onDisLike: () =>
                                                dislikeThreadMessage(
                                                    userThread[index].id),
                                            onLike: () => likeThreadMessage(
                                                userThread[index].id),
                                            onComment: () {},
                                            panelController: panelController,
                                          ),
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              const Center(
                                child: Text('Your replies here'),
                              ),
                              const Center(
                                child: Text('Your reposts here'),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          )),
        ),
      ),
    );
  }

  Future<void> likeThreadMessage(String id) async {
    try {
      threadCollection.doc(id).update({
        'likes': FieldValue.arrayUnion([widget.targetUserEmail!])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> dislikeThreadMessage(String id) async {
    try {
      threadCollection.doc(id).update({
        'likes': FieldValue.arrayRemove([widget.targetUserEmail!])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget displayButtons() {
    if (isCurrentUser) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (isPanelOpen) {
                panelController.close();
              } else {
                panelController.open();
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Edit profile'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Share profile'),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Logout'),
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Follow'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Message'),
            ),
          )
        ],
      );
    }
  }
}
