import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/user_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/auth.controller.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chatlist/chat_tile.dart';
import 'package:get/get.dart';

import '../../app/app_refs.dart';
import '../../app/di.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final appPreference = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    final User currentUser = appPreference.getCurrentUser();

    Get.lazyPut(() => ChatController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${currentUser.username}"),
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
          // initState: (state) => ChatController().onInit(),
          builder: (controller) {
            return Obx(() {
              if (controller.chatList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return ListView.builder(
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
