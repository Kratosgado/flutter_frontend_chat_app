import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:get/get.dart';

class UserListView extends GetView<ServerController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: GetBuilder<ServerController>(
        initState: (state) => controller.fetchUsers(),
        builder: (controller) {
          return Obx(
            () => ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (context, index) {
                var user = controller.usersList[index];
                return ListTile(
                  title: Text(user.username ?? "No name"),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
