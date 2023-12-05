import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:get/get.dart';

class UserListView extends GetView<ServerController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ServerController());
    return GetBuilder(
      init: controller,
      initState: (state) => controller.fetchUsers(),
      builder: (context) => ListView.builder(
        itemCount: controller.userList.length,
        itemBuilder: (context, index) {
          var user = controller.userList[index];
          return ListTile(
            title: Text(user.email),
          );
        },
      ),
    );
  }
}
