import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat_controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/chat_tile.dart';
import 'package:get/get.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello User"),
        actions: [
          IconButton(
            onPressed: () => ServerController().logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.s12),
        child: GetBuilder<ChatController>(
          init: ChatController(),
          // initState: (state) => controller.fetchChats(),
          builder: (controller) {
            return Obx(
              () => ListView.builder(
                itemCount: controller.chatList.length,
                itemBuilder: (context, index) {
                  var chat = controller.chatList[index];
                  return Column(
                    children: [
                      chatTile(chat),
                      const Divider(height: 0.1, thickness: 0.5),
                    ],
                  );
                },
              ),
            );
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
