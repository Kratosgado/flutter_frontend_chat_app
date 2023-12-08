// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'chat_model.dart';
import 'picture_model.dart';
import 'user_model.dart';

class Message {
  final String? id;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final String content;
  final Picture? picture;
  final String? pictureId;
  final String? chatId;
  final String? senderId;

  Message({
    required this.id,
    // required this.createdAt,
    // required this.updatedAt,
    required this.content,
    this.picture,
    this.pictureId,
    required this.chatId,
    required this.senderId,
  });

  Message copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? content,
    Picture? picture,
    String? pictureId,
    Chat? chat,
    String? chatId,
    User? sender,
    String? senderId,
  }) {
    return Message(
      id: id ?? this.id,
      // createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      picture: picture ?? this.picture,
      pictureId: pictureId ?? this.pictureId,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
      // 'updatedAt': updatedAt.millisecondsSinceEpoch,
      'content': content,
      'picture': picture?.toMap(),
      'pictureId': pictureId,
      'chatId': chatId,
      'senderId': senderId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      // updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      content: map['content'] as String,
      picture:
          map['picture'] != null ? Picture.fromMap(map['picture'] as Map<String, dynamic>) : null,
      pictureId: map['pictureId'] != null ? map['pictureId'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
