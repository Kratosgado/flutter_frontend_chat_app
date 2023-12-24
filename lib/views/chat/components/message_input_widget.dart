import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';

class MessageInputWidget extends StatelessWidget {
  final String chatId;
  MessageInputWidget({super.key, required this.chatId});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                ChatController().sendMessage(messageController.text, chatId);
                messageController.clear();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
