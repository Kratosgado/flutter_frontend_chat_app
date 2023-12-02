import 'chat_model.dart';
import 'message_model.dart';
import 'user_model.dart';

class Picture {
  final String id;
  final String url;
  final User user;
  final String userId;
  final Chat chat;
  final String chatId;
  final String? messageId;
  final Message? message;

  Picture({
    required this.id,
    required this.url,
    required this.user,
    required this.userId,
    required this.chat,
    required this.chatId,
    this.messageId,
    this.message,
  });
}
