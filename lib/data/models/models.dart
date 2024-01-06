// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String username;
  String? profilePic;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final List<Chat> conversations;
  // final List<Message> messages;
  // final List<Picture> pictures;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.profilePic,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Message {
  final String id;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final String text;
  final String? picture;
  final String? chatId;
  // final chat = IsarLink<Chat>();
  final String? senderId;

  Message({
    required this.id,
    // required this.createdAt,
    // required this.updatedAt,
    required this.text,
    this.picture,
    required this.chatId,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Chat {
  final String id;

  final String convoName;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final List<Message> messages;
  final List<User> users;

  Chat({
    required this.id,
    required this.convoName,
    required this.messages,
    required this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
