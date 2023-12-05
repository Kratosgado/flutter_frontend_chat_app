// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'chat_model.dart';
import 'message_model.dart';
import 'user_model.dart';

class Picture {
  final String id;
  final String url;
  final String userId;
  final String chatId;
  final String? messageId;

  Picture({
    required this.id,
    required this.url,
    required this.userId,
    required this.chatId,
    this.messageId,
  });

  Picture copyWith({
    String? id,
    String? url,
    User? user,
    String? userId,
    Chat? chat,
    String? chatId,
    String? messageId,
    Message? message,
  }) {
    return Picture(
      id: id ?? this.id,
      url: url ?? this.url,
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'userId': userId,
      'chatId': chatId,
      'messageId': messageId,
    };
  }

  factory Picture.fromMap(Map<String, dynamic> map) {
    return Picture(
      id: map['id'] as String,
      url: map['url'] as String,
      userId: map['userId'] as String,
      chatId: map['chatId'] as String,
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Picture.fromJson(String source) =>
      Picture.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Picture other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.url == url &&
        other.userId == userId &&
        other.chatId == chatId &&
        other.messageId == messageId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ url.hashCode ^ userId.hashCode ^ chatId.hashCode ^ messageId.hashCode;
  }
}
