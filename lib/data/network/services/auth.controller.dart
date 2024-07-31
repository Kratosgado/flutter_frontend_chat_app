import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/backend.models.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:flutter_frontend_chat_app/resources/styles_manager.dart';
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
        debugPrint(response.bodyString);
        await me(response.body).then((user) async {
          if (user != null) {
            final currentAccount = Account(id: user.id, user: user, isActive: true)
              ..password = signUpData.password
              ..token = response.body
              ..isActive = true;
            await SocketService.hiveService.addAccount(currentAccount);
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
          backgroundGradient: StyleManager.boxDecoration.gradient,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
        Get.snackbar(
          "Register?",
          "Will you like to register to gain access?",
          snackStyle: SnackStyle.FLOATING,
          backgroundGradient: StyleManager.boxDecoration.gradient,
          isDismissible: true,
          dismissDirection: DismissDirection.up,
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () {
              final usernameController = TextEditingController();
              Get.snackbar(
                "Username",
                "Enter your username",
                snackStyle: SnackStyle.FLOATING,
                backgroundGradient: StyleManager.boxDecoration.gradient,
                dismissDirection: DismissDirection.up,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(minutes: 1),
                userInputForm: Form(
                  child: TextFormField(
                    autocorrect: true,
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onFieldSubmitted: (username) {
                      signUp(
                          signUpData: SignUpData(
                              email: signUpData.email,
                              password: signUpData.password,
                              username: username));
                      Get.closeCurrentSnackbar();
                    },
                  ),
                ),
              );
            },
            child: const Text('Yes'),
          ),
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

  Future<void> switchCurrentUser(Account account) async {
    account.isActive = true;
    await SocketService.hiveService.addAccount(account);
    await SocketService.to.onClose();
    await initService();
    await Get.offAllNamed(Routes.splashRoute);
  }

  Future<void> logout() async {
    await SocketService.to.onClose();
    Get.offAllNamed(Routes.loginRoute);
  }
}
