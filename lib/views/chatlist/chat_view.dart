import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat app")),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return MessageWidget(message: message);
            },
          ))
        ],
      ),
    );
  }
}

List<Message> messages = [
  Message(id: "sljfoi", content: "hello", conversationId: "lksf", senderId: "ldfsj"),
];
