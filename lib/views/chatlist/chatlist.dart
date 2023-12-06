import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:get/get.dart';

class ChatListView extends GetView<ServerController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ServerController());
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
      body: GetBuilder<ServerController>(
        initState: (state) => controller.fetchChats(),
        builder: (controller) {
          return Obx(
            () => ListView.builder(
              itemCount: controller.chatList.length,
              itemBuilder: (context, index) {
                var chat = controller.chatList[index];
                return ListTile(
                  title: Text(chat.convoName),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.message_rounded),
        onPressed: () => Get.toNamed(Routes.userList),
      ),
    );
  }
}
