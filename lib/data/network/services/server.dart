// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/chat_model.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/data/models/user_model.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

class ServerController extends GetxController {
  final _appPreference = instance<AppPreferences>();

  final connect = GetConnect();

  Future<void> signUp({required SignUpData signUpData}) async {
    try {
      final response = await connect.post(
        ServerStrings.signup,
        {
          "username": signUpData.username,
          "email": signUpData.email,
          "password": signUpData.password
        },
      );
      if (response.isOk) {
        await signIn(signUpData);
      }
      if (response.hasError) {
        debugPrint("server error: $response");
        const AlertDialog(
          actions: [ActionChip.elevated(label: Text('ok'))],
          content: AboutDialog(),
        );
        Get.snackbar(response.statusCode.toString(), response.statusText!);
      }
    } catch (e) {
      const AlertDialog(
        actions: [ActionChip.elevated(label: Text('ok'))],
      );
    }
  }

  Future<void> signIn(SignUpData signUpData) async {
    try {
      Response response = await connect.post(
        ServerStrings.signin,
        {"email": signUpData.email, "password": signUpData.password},
      );
      await _appPreference.setUserTokenn(response.body);

      if (response.isOk) {
        await _appPreference.setIsUserLoggedIn();

        Get.offAllNamed(Routes.chatList);
      }
    } catch (err) {
      Get.dialog(Text(err.toString()), barrierColor: ColorManager.error);
    }
  }

  final chatList = RxList<Chat>();

  void fetchChats() async {
    try {
      var response = await connect.get(
        ServerStrings.getChats,
        headers: {"Authorization": await _appPreference.getUserToken()},
      );
      if (response.isOk) {
        chatList.value = response.body.map((chat) => Chat.fromJson(chat)).toList();
      }
    } catch (err) {
      Get.snackbar("Error Fetching chats", err.toString());
    }
  }

  final userList = RxList<User>();

  void fetchUsers() async {
    try {
      var response = await connect.get(ServerStrings.getUsers);
      if (response.isOk) {
        userList.value = response.body.map((user) => User.fromJson(user)).toList();
      }
    } catch (err) {
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
