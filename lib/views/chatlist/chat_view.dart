import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message_input_widget.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  String? chatId;
  ChatView({super.key, this.chatId}) {
    chatId = chatId ?? Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
              ChatController.fetchChats();
            },
          ),
          title: Text(SocketService.openedChat.value.convoName)),
      body: GetBuilder<ChatController>(
        initState: (_) => ChatController.findOneChat(chatId),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Obx(() {
                  RxList<Message> messages = SocketService.openedChat.value.messages.obs;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageWidget(message: message);
                    },
                  );
                }),
              ),
              MessageInputWidget(
                chatId: chatId!,
              )
            ],
          );
        },
      ),
    );
  }
}
