import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/auth.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/chat_tile.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/leading.tile.dart';
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
            onPressed: () => AuthController().logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.s12),
        child: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (controller) {
            return Obx(() {
              if (SocketService.chatList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return ListView.builder(
                itemCount: SocketService.chatList.length,
                itemBuilder: (context, index) {
                  var chat = SocketService.chatList[index];
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
            });
          },
        ),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.message_rounded),
        onPressed: () => Get.toNamed(Routes.userList),
      ),
    );
  }
}
