import 'chat_model.dart';
import 'message_model.dart';
import 'picture_model.dart';

class User {
  final String id;
  final String email;
  final String? username;
  final String? profilePic;
  final String password;
  final String salt;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final List<Chat> conversations;
  // final List<Message> messages;
  // final List<Picture> pictures;

  User({
    required this.id,
    required this.email,
    this.username,
    this.profilePic,
    required this.password,
    required this.salt,
    required this.createdAt,
    required this.updatedAt,
    // required this.conversations,
    // required this.messages,
    // required this.pictures,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profilePic: json['profilePic'],
      password: json['password'],
      salt: json['salt'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profilePic': profilePic,
      'password': password,
      'salt': salt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
