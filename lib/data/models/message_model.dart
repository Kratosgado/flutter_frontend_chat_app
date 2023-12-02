
import 'chat_model.dart';
import 'picture_model.dart';
import 'user_model.dart';

class Message {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final Picture? picture;
  final String? pictureId;
  final Chat? conversation;
  final String? conversationId;
  final User? sender;
  final String? senderId;

  Message({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    this.picture,
    this.pictureId,
    this.conversation,
    this.conversationId,
    this.sender,
    this.senderId,
  });
}
