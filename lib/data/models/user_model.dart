// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String email;
  final String? username;
  final String? profilePic;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final List<Chat> conversations;
  // final List<Message> messages;
  // final List<Picture> pictures;

  User({
    required this.id,
    required this.email,
    this.username,
    this.profilePic,
    // required this.createdAt,
    // required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePic,
    String? password,
    String? salt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      // createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'profilePic': profilePic,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
      // 'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] != null ? map['username'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      // updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
