import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message.widget.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message.input.widget.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  final String chatId;
   ChatView({super.key, this.chatId = ""}){
    ChatController.to.findOneChat(chatId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: SocketService.isarService.streamChat(chatId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final chat = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                    // ChatController.to.fetchChats();
                  },
                ),
                title: Text(chat.convoName)),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      final message = chat.messages.elementAt(index);
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
