

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/chat_model.dart';

class ChatController extends GetxController {
  final _appPreference = instance<AppPreferences>();
  final chatList = RxList<Chat>();
  final connect = GetConnect();

  
Future<void> fetchChats() async {
    try {
      var response = await connect.get(
        ServerStrings.getChats,
        headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"},
        decoder: (data) => data.map((chat) => Chat.fromMap(chat)).toList(),
      );
      if (response.isOk) {
        chatList.value = TypeDecoder.fromMapList<Chat>(response.body);
        debugPrint("chats retrieved: ${chatList.length}");
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

    Future<void> getChat(String id) async {
    Response response = await connect.get("${ServerStrings.getChat}$id",
        headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"});
    if (response.isOk) {
      Get.snackbar(response.statusCode.toString(), response.statusText.toString());
    }
  }
}