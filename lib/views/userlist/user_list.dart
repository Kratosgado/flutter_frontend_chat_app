import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/auth.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/user.controller.dart';
import 'package:get/get.dart';

class UserListView extends GetView<UserController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserController());
    final chatController = Get.find<ChatController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () => AuthController().logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: GetBuilder<UserController>(
        initState: (state) => controller.fetchUsers(),
        builder: (controller) {
          return Obx(
            () => ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (context, index) {
                var user = controller.usersList[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        debugPrint(user.id);
                        chatController.createChat(user.id);
                      },
                      title: Text(user.username!),
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
