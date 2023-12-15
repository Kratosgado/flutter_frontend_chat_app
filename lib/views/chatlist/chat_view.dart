import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
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
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.openedChat.value.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.openedChat.value.messages[index];
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