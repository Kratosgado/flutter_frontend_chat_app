import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message_input_widget.dart';

class ChatView extends StatelessWidget {
  final String chatId;
  const ChatView({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
          title: const Text("Chat app")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageWidget(message: message);
              },
            ),
          ),
           MessageInputWidget(
            chatId: chatId,
          )
        ],
      ),
    );
  }
}

List<Message> messages = [
  Message(id: "sljfoi", content: "hello", chatId: "lksf", senderId: "ldfsj"),
];
