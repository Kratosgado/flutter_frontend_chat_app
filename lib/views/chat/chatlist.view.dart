import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/models.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/chat.tile.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/leading.tile.dart';
import 'package:flutter_frontend_chat_app/views/utils/account.tile.dart';
import 'package:flutter_frontend_chat_app/views/utils/accounts.sheet.dart';
import 'package:get/get.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = SocketService.currentUser;

    Get.lazyPut(() => ChatController());
    return Scaffold(
      appBar: AppBar(
        leading: leadingTile(),
        title: Text(
          "Hello ${currentUser.username}",
        ),
        actions: [
          IconButton(
            onPressed: () => accountsSheet,
            icon: const Icon(Icons.opacity_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.s12),
        child: StreamBuilder(
            stream: SocketService.isarService.streamChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error loading chats"),
                );
              }
              final chatList = snapshot.data!;
              return ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final chat = chatList[index];
                  return Column(
                    children: [
                      chatTile(chat),
                      const Divider(
                        height: 0.1,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ],
                  );
                },
              );
            }),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.message_rounded),
        onPressed: () => Get.toNamed(Routes.userList),
      ),
    );
  }
}
