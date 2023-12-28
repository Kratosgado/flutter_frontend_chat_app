import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message_input_widget.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  String? chatId;
  ChatView({super.key, this.chatId}) {
    chatId = chatId ?? Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    ChatController.findOneChat(chatId);

    return Obx(() {
      final openedChat = SocketService.openedChat.value;

      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
                ChatController.fetchChats();
              },
            ),
            title: Text(openedChat.convoName)),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: openedChat.messages.length,
                itemBuilder: (context, index) {
                  final message = openedChat.messages[index];
                  return MessageWidget(message: message);
                },
              ),
            ),
            MessageInputWidget(
              chatId: chatId!,
            )
          ],
        ),
      );
    });
  }
}
