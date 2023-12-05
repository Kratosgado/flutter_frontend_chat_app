// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'message_model.dart';
import 'picture_model.dart';
import 'user_model.dart';

class Chat {
  final String id;
  final String? convoName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;
  final List<User> users;
  final List<Picture> pictures;

  Chat({
    required this.id,
    this.convoName,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.users,
    required this.pictures,
  });

  Chat copyWith({
    String? id,
    String? convoName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Message>? messages,
    List<User>? users,
    List<Picture>? pictures,
  }) {
    return Chat(
      id: id ?? this.id,
      convoName: convoName ?? this.convoName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      users: users ?? this.users,
      pictures: pictures ?? this.pictures,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'convoName': convoName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'messages': messages.map((x) => x.toMap()).toList(),
      'pictures': pictures.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      convoName: map['convoName'] != null ? map['convoName'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      messages: List<Message>.from((map['messages'] as List<int>).map<Message>((x) => Message.fromMap(x as Map<String,dynamic>),),),
      users: List<User>.from((map['users'] as List<int>).map<User>((x) => User.fromMap(x as Map<String,dynamic>),),),
      pictures: List<Picture>.from((map['pictures'] as List<int>).map<Picture>((x) => Picture.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);


}
