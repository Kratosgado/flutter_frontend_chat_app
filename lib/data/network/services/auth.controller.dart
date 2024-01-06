import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
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
        debugPrint("server error: $response");
        const AlertDialog(
          actions: [ActionChip.elevated(label: Text('ok'))],
          content: AboutDialog(),
        );
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

  /// send login request to server
  Future<void> login(SignUpData signUpData) async {
    try {
      Response response = await post(
        ServerStrings.login,
        {"email": signUpData.email, "password": signUpData.password},
      );

      if (response.isOk) {
        await SocketService.appPreference.setUserToken(response.body);

        await SocketService.appPreference.setIsUserLoggedIn();
        await me().then((user) async {
          if (user != null) {
            final currentAccount = Account()
              ..username = user.username
              ..email = user.email
              ..password = signUpData.password
              ..isActive = true;

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

  Future<User?> me() async {
    try {
      Response res = await get(
        ServerStrings.getMe,
        headers: {'Authorization': "Bearer ${await SocketService.appPreference.getUserToken()}"},
        decoder: (data) => User.fromJson(data),
      );

      if (res.isOk) {
        await SocketService.appPreference.setCurrentUser(res.body);
        debugPrint("details saved");
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
