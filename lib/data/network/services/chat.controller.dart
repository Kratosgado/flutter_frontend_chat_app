import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:get/get.dart';
import '../../../resources/string_manager.dart';

class ChatController extends GetxController {
  @override
  Future<void> onInit() async {
    await fetchChats();

    super.onInit();
  }

  static Future<void> fetchChats() async {
    try {
      debugPrint("fetching chats of user");
      SocketService.socket.emit(ServerStrings.getChats);
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar("Error Fetching chats", err.toString());
    }
  }

  // send message to recieve chats
  static void findOneChat(chatId) {
    debugPrint("finding chat with id: $chatId");
    SocketService.socket.emit(ServerStrings.findOneChat, chatId);
  }

  void sendMessage(String content, String chatId) async {
    try {
      SocketService.socket.emit(
        ServerStrings.sendMessage,
        {"content": content, "chatId": chatId},
      );
      debugPrint("sending message: $content");
    } catch (e) {
      debugPrint(3.toString());
      Get.snackbar("Error Fetching chats", e.toString());
    }
  }

  Future<void> createChat(String userId) async {
    try {
      SocketService.socket.emit(ServerStrings.createChat, {
        "userIds": [userId]
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> deleteChat(String chatId) async {
    try {
      SocketService.socket.emit(ServerStrings.deleteChat, chatId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}