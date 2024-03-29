import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/hive.service.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message.widget.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message.input.widget.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/models.dart';

class ChatView extends StatelessWidget {
  final String chatId;
  ChatView({super.key, this.chatId = ""}) {
    ChatController().findOneChat(chatId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Chat>(HiveService.chatsBoxName).listenable(keys: [chatId]),
        builder: (context, box, _) {
          final chat = box.values.firstWhere((element) => element.id == chatId);
          return Scaffold(
            appBar: AppBar(
                leading: BackButton(
                  onPressed: () => Get.back(),
                ),
                title: Text(chat.convoName)),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      final message = chat.messages[index];
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
        });
  }
}
