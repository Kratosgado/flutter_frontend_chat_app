import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:get/get.dart';

import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/models.dart';

class UserController extends GetxController {
  var usersList = <User>[].obs;

  final connect = GetConnect();

  @override
  Future<void> onInit() async {
    await fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await connect.get(
        ServerStrings.getUsers,
        // decoder: (data) => data.map((user) => User.fromJson(user)).toList(),
      );
      if (response.isOk) {
        final users = response.body.map((user) => User.fromJson(user)).toList();
        usersList.value = TypeDecoder.fromMapList(users);
        debugPrint("Users retrieved: ${usersList.length}");
      }
      if (response.hasError) {
        debugPrint("server error: $response");
        Get.snackbar(response.statusCode.toString(), response.statusText!);
      }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final response = await connect.put(ServerStrings.updateUser, user.toJson(),
          headers: {"Authorization": "Bearer ${SocketService.currentAccount.token}"});
      if (response.isOk) {
        final user = User.fromJson(response.body);
        SocketService.currentAccount.user = user;
        await SocketService.currentAccount.save();
      }
      if (response.hasError) {
        debugPrint("server error: ${response.statusText}");
        Get.snackbar(response.statusCode.toString(), response.statusText!);
      }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
