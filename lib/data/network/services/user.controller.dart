import 'dart:io';

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

  Future<void> updateProfilePic(File selectedImage) async {
    try {
      final formData = FormData({"image": selectedImage});
      final response = await connect.put(ServerStrings.updateProfilePicture, formData,
          headers: {"Authorization": "Bearer ${SocketService.token}"});
      if (response.isOk) {
        debugPrint("image updated successfully");
        // TODO: update user data
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
