import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final currentUser =  SocketService.currentUser;

    return Container(
      padding: const EdgeInsets.all(8),
      alignment: message.senderId == currentUser.id ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(message.content),
    );
  }
}
