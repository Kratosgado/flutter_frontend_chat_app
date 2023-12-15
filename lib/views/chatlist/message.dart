import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app_refs.dart';
import 'package:flutter_frontend_chat_app/app/di.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final currentUser = instance<AppPreferences>().getCurrentUser();

    return Container(
      padding: const EdgeInsets.all(8),
      alignment: message.senderId == currentUser.id ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(message.content),
    );
  }
}
