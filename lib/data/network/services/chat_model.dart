

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
}
