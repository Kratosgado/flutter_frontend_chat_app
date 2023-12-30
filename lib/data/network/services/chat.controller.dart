import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:get/get.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/chat_model.dart';

class ChatController extends GetxController with StateMixin<List<Chat>>{
  RxList<Chat> chatList = <Chat>[].obs;

  // final socket = SocketService.to.so
  static ChatController get to => Get.find();

  @override
  Future<void> onInit() async {
    await fetchChats();
    super.onInit();
  }

  Future<void> fetchChats() async {
    try {
      debugPrint("fetching chats of user");
      SocketService.socket.emit(ServerStrings.getChats);
      change(chatList, status: RxStatus.loading());
      SocketService.socket.on(ServerStrings.returningChats, (data) async {
        final source = data.map((chat) => Chat.fromMap(chat)).toList();
        debugPrint("chats recieved: ${source.length}");

        final chats = TypeDecoder.fromMapList<Chat>(source);
        for (var chat in chats) {
          for (var user in chat.users) {
            if (user.profilePic != null) {
              user.profilePic = await TypeDecoder.saveImageAsAsset(user.profilePic!);
            }
          }
        }
        chatList.value = chats;
        if (chatList.isEmpty) {
          change(chatList, status: RxStatus.empty());
        } else {
          change(chatList, status: RxStatus.success());
        }
      });
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar("Error Fetching chats", err.toString());
    }
  }

  // send message to recieve chats
  void findOneChat(chatId) {
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

  Future<void> deleteChat(String chatId) async {
    try {
      SocketService.socket.emit(ServerStrings.deleteChat, chatId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
