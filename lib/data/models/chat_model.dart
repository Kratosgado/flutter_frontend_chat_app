// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'message_model.dart';
import 'picture_model.dart';
import 'user_model.dart';

class Chat {
  final String id;
  final String convoName;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final List<Message>? messages;
  final List<User> users;
  final List<Picture>? pictures;

  Chat({
    required this.id,
    required this.convoName,
    this.messages,
    required this.users,
    this.pictures,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'convoName': convoName,
      'messages': messages?.map((x) => x.toMap()).toList(),
      'users': users.map((x) => x.toMap()).toList(),
      'pictures': pictures?.map((x) => x.toMap()).toList(),
    };
  }

  List<Chat> fromMapList(List<Map<String, dynamic>> list) {
    return Iterable.castFrom<dynamic, Chat>(list).toList();
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      convoName: map['convoName'] as String,
      messages: map['messages'].length != null
          ? List<Message>.from(
              (map['messages'] as List<dynamic>).map<Message?>(
                (x) => Message.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      users: List<User>.from(
        (map['users'] as List<dynamic>).map<User>(
          (x) => User.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pictures: map['pictures'] != null
          ? List<Picture>.from(
              (map['pictures'] as List<Picture>).map<Picture?>(
                (x) => Picture.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
