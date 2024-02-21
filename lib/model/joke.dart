// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Joke {
  final String id;
  final String email;
  final String senderName;
  final String senderProfileImageUrl;
  final String message;
  final DateTime timestamp;
  final List likes;
  final List comments;

  Joke({
    required this.id,
    required this.email,
    required this.senderName,
    required this.senderProfileImageUrl,
    required this.message,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'senderName': senderName,
      'senderProfileImageUrl': senderProfileImageUrl,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'likes': likes,
      'comments': comments
    };
  }

  factory Joke.fromMap(Map<String, dynamic> map) {
    return Joke(
      id: map['id'] as String,
      email: map['email'] as String,
      senderName: map['senderName'] as String,
      senderProfileImageUrl: map['senderProfileImageUrl'] as String,
      message: map['message'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      likes: List.from((map['likes'] as List)),
      comments: List.from((map['comments'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Joke.fromJson(String source) =>
      Joke.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Joke.empty() {
    return Joke(
        id: '',
        email: '',
        senderName: '',
        senderProfileImageUrl: '',
        message: '',
        timestamp: DateTime.now(),
        likes: [],
        comments: []);
  }
}
