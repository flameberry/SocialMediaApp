import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social_media_app/model/joke.dart';

class FBYPost extends StatelessWidget {
  FBYPost({
    super.key,
    required this.message,
    required this.onLike,
    required this.onDisLike,
    required this.onComment,
    required this.panelController,
  });

  final Joke message;
  final void Function() onLike;
  final void Function() onDisLike;
  final void Function() onComment;

  final PanelController panelController;
  final userId = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Padding(
            padding: EdgeInsets.only(top: 10 * (1.0 - value)),
            child: child,
          ),
        );
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
              backgroundImage: NetworkImage(message.senderProfileImageUrl),
              backgroundColor: Colors.white,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.senderName,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      _getTimeDifference(message.timestamp),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                Text(
                  message.message,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Inter",
                    height: 1.2,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (message.likes.contains(userId)) {
                            onDisLike();
                          } else {
                            onLike();
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: message.likes.contains(userId)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  key: Key('like'),
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  key: Key('unlike'),
                                ),
                        ),
                      ),
                      message.likes.isEmpty
                          ? message.comments.isEmpty
                              ? Container()
                              : const Text('')
                          : Text(message.likes.length.toString()),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          panelController.open();
                          onComment();
                        },
                        child: const Icon(Icons.mode_comment_outlined),
                      ),
                      message.comments.isEmpty
                          ? message.likes.isEmpty
                              ? Container()
                              : const Text('')
                          : Text(message.comments.length.toString()),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/retweet.png",
                          width: 25,
                        ),
                      ),
                      message.likes.isNotEmpty || message.comments.isNotEmpty
                          ? const Text('')
                          : Container(),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/send.png",
                          width: 20,
                        ),
                      ),
                      message.likes.isNotEmpty || message.comments.isNotEmpty
                          ? const Text('')
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hr';
    } else {
      return '${difference.inDays} day';
    }
  }
}
