import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/message_input_widget.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  String? chatId;
  ChatView({super.key, this.chatId}) {
    chatId = chatId ?? Get.arguments.chatId;
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          title: const Text("Chat app")),
      body: GetBuilder<ChatController>(
        initState: (_) => chatController.findOneChat(chatId),
        builder: (controller) {

          return Obx(() {
            final messages = SocketService.openedChat.value.messages;
            return Column(
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
                  chatId: chatId!,
                )
              ],
            );
          });
        },
      ),
    );
  }
}
