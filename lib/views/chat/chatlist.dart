import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/chat_tile.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/leading.tile.dart';
import 'package:flutter_frontend_chat_app/views/utils/account.tile.dart';
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
            onPressed: () {
              Get.bottomSheet(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: Spacing.s60,
                      margin: const EdgeInsets.all(Spacing.s4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.teal,
                      ),
                    ),
                    accountTile(currentUser),
                  ],
                ),
                elevation: Spacing.s10,
              );
            },
            // onPressed: () => AuthController().logout(),

            icon: const Icon(Icons.opacity_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.s12),
        child: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (controller) {
            return controller.obx(
              (chatList) {
                return ListView.builder(
                  itemCount: chatList?.length,
                  itemBuilder: (context, index) {
                    final chat = chatList?[index];
                    return Column(
                      children: [
                        chatTile(chat!),
                        const Divider(
                          height: 0.1,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ],
                    );
                  },
                );
              },
              onEmpty: const Center(
                child: Text("No conversation yet"),
              ),
              onError: (err) => Center(child: Text(err.toString())),
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
