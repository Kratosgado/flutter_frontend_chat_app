import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app_refs.dart';
import 'package:flutter_frontend_chat_app/app/di.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat_controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:flutter_frontend_chat_app/data/network/services/user_controller.dart';
import 'package:get/get.dart';

class UserListView extends GetView<UserController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = instance<AppPreferences>().getCurrentUser();

    Get.lazyPut(() => UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () => ServerController().logout(),
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
                        ChatController().createChat(user.id);
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
