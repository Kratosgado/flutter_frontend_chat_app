// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'chat_model.dart';
import 'picture_model.dart';
import 'user_model.dart';

class Message {
  final String? id;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final String text;
  final String? picture;
  final String? chatId;
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
      // 'updatedAt': updatedAt.millisecondsSinceEpoch,
      'text': text,
      'picture': picture,
      'chatId': chatId,
      'senderId': senderId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      // updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      text: map['text'] as String,
      picture: map['picture'] as String,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
