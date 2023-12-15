

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/user_model.dart';

class UserController extends GetxController {
  var usersList = <User>[].obs;

  final connect = GetConnect();


  void fetchUsers() async {
    try {
      var response = await connect.get(
        ServerStrings.getUsers,
        decoder: (data) => data.map((user) => User.fromMap(user)).toList(),
      );
      if (response.isOk) {
        usersList.value = TypeDecoder.fromMapList(response.body);
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
}