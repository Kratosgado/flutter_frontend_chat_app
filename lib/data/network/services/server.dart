// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/chat_model.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/data/models/user_model.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

class ServerController extends GetxController {
  final _appPreference = instance<AppPreferences>();
  final chatList = RxList<Chat>();
  var usersList = <User>[].obs;

  final connect = GetConnect();

  // @override
  // void onInit() async {
  //   await fetchChats();
  //   super.onInit();
  // }

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

  Future<void> logout() async {
    await _appPreference.logout();
    Get.offNamed(Routes.loginRoute);
  }

  Future<void> fetchChats() async {
    try {
      var response = await connect.get(
        ServerStrings.getChats,
        headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"},
        decoder: (data) => data.map((chat) => Chat.fromMap(chat)).toList(),
      );
      if (response.isOk) {
        debugPrint("chats ${response.body}");
        chatList.value = TypeDecoder.fromMapList<Chat>(response.body);
      }
      if (response.hasError) {
        debugPrint("server error: ${response.body}");

        Get.snackbar(response.statusCode.toString(), response.statusText!);
      }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar("Error Fetching chats", err.toString());
    }
  }

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
