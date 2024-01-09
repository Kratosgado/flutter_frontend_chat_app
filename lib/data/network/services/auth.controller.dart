import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:get/get.dart';

import '../../../app/di.dart';
import '../../models/models.dart';

class AuthController extends GetConnect {
  Future<void> signUp({required SignUpData signUpData}) async {
    try {
      final response = await post(
        ServerStrings.signup,
        {
          "username": signUpData.username,
          "email": signUpData.email,
          "password": signUpData.password
        },
      );
      if (response.isOk) {
        await login(signUpData);
      }
      if (response.hasError) {
        debugPrint("server error: ${response.body.toString()}");
        const AlertDialog(
          actions: [ActionChip.elevated(label: Text('ok'))],
          content: AboutDialog(),
        );
        Get.snackbar(response.statusText.toString(), response.body["message"]);
        if (response.statusCode == 409) {
          await login(signUpData);
        }
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

  /// send login request to server
  Future<void> login(SignUpData signUpData) async {
    try {
      Response response = await post(
        ServerStrings.login,
        {"email": signUpData.email, "password": signUpData.password},
      );

      if (response.isOk) {
        await me(response.body).then((user) async {
          if (user != null) {
            final currentAccount = Account()
              ..id = user.id
              ..password = signUpData.password
              ..token = response.body
              ..isActive = true
              ..user = user;
            await SocketService.isarService.addAccount(currentAccount);
          }
        });

        Get.lazyPut(() => ChatController());
        await initService();

        Get.offAllNamed(Routes.chatList);
      }
      if (response.hasError) {
        debugPrint(response.body["message"]);
        Get.snackbar(
          response.body["error"],
          response.body["message"],
          snackPosition: SnackPosition.BOTTOM,
        );
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

  Future<User?> me(String token) async {
    try {
      Response res = await get(
        ServerStrings.getMe,
        headers: {'Authorization': "Bearer $token"},
        decoder: (data) => User.fromJson(data),
      );

      if (res.isOk) {
        return res.body as User;
      }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  Future<void> logout() async {
    SocketService().onClose();
    Get.offAllNamed(Routes.loginRoute);
  }
}
