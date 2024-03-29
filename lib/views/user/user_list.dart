import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/auth.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/data/network/services/user.controller.dart';
import 'package:get/get.dart';

class UserListView extends GetView<UserController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () async => await AuthController().logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: GetBuilder<UserController>(
        init: UserController(),
        builder: (controller) {
          return Obx(
            () => ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (context, index) {
                final user = controller.usersList[index];
                if (user.id == SocketService.currentAccount.id) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        debugPrint(user.id);
                        ChatController().createChat(user.id);
                      },
                      title:
                          Text(user.id == SocketService.currentAccount.id ? "Me" : user.username!),
                    ),
                    const Divider(
                      height: 0.2,
                      thickness: 0.5,
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
