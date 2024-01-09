import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:get/get.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/models.dart';

class ChatController extends GetxController with StateMixin<List<Chat>> {
  // final socket = SocketService.to.so
  static ChatController get to => Get.find();

  Future<void> fetchChats() async {
    try {
      debugPrint("fetching chats of user");
      SocketService.socket.emit(ServerStrings.findAllChats);

      SocketService.socket.on(ServerStrings.returningChats, (data) async {
        final source = data.map((chat) => Chat.fromJson(chat)).toList();
        debugPrint("chats recieved: ${source.length}");

        final chats = TypeDecoder.fromMapList<Chat>(source);

        for (var chat in chats) {
          for (var user in chat.users) {
            if (user.profilePic != null) {
              user.profilePic = await TypeDecoder.saveImageAsAsset(user.profilePic!);
            }
          }
        }

        SocketService.isarService.addChats(chats);
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

  void sendMessage(Message message) async {
    try {
      SocketService.socket.emit(
        ServerStrings.sendMessage,
        message.toJson(),
      );
      debugPrint("sending message: ${message.text}");

    SocketService.socket.on(ServerStrings.newMessage, (data) {
      try {
        // fetchChats();
        final message = Message.fromJson(data);
        

        SocketService.socket.emit(ServerStrings.deleteSocketMessage, message.id);
        Get.snackbar("Chat App", message.text);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
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
