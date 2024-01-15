import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/views/chat/chat.view.dart';
import 'package:get/get.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/models.dart';

class ChatController {
  Future<void> fetchChats() async {
    try {
      debugPrint("fetching chats of user");
      SocketService.socket.emit(ServerStrings.findAllChats);

      SocketService.socket.on(ServerStrings.returningChats, (data) async {
        final source = data.map((chat) => Chat.fromJson(chat)).toList();
        debugPrint("chats recieved: ${source.length}");

        final chats = TypeDecoder.fromMapList<Chat>(source);
        SocketService.hiveService.addChats(chats);
      });
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar("Error Fetching chats", err.toString());
    }
  }

  // send message to recieve chats
  void findOneChat(chatId) {
    try {
      debugPrint("finding chat with id: $chatId");
      SocketService.socket.emit(ServerStrings.findOneChat, chatId);
      SocketService.socket.on(ServerStrings.returningChat, (data) async {
        try {
          final chat = Chat.fromJson(data);
          debugPrint("recieved chat id: ${chat.id}");
          SocketService.hiveService.updateChat(chat);
        } catch (err) {
          debugPrint(err.toString());
          Get.snackbar("Chat recieving error", err.toString());
        }
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void sendMessage(Message message) async {
    try {
      SocketService.socket.emit(
        ServerStrings.sendMessage,
        message.toJson(),
      );
      debugPrint("sending message with Id: ${message.id}");

      SocketService.socket.on(ServerStrings.newMessage, (data) {
        try {
          // fetchChats();
          final message = Message.fromJson(data);

          SocketService.hiveService.updateMessage(message);
          // SocketService.socket.emit(ServerStrings.deleteSocketMessage, message.id);
          Get.snackbar(
            "Chat App",
            message.text,
            duration: const Duration(seconds: 1),
            isDismissible: true,
          );
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

      SocketService.socket.on(ServerStrings.chatCreated, (data) async {
        try {
          debugPrint("chat created: ${data.toString()}");
          final createdChat = Chat.fromJson(data);
          await SocketService.hiveService.addChats([createdChat]).then(
              (value) => {Get.off(() => ChatView(chatId: createdChat.id))});
          // Get.offNamed(Routes.chat, arguments: createdChat.id);
          // SocketService.socket.emit(ServerStrings.deleteSocketMessage, createdChat.id);
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteMessage(String id) async {
    try {
      SocketService.socket.emit(ServerStrings.deleteMessage, id);
      SocketService.socket.on(ServerStrings.messageDeleted, (data) {
        // TODO: delete message
      });
    } catch (e) {
      debugPrint(e.toString());

    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      SocketService.socket.emit(ServerStrings.deleteChat, chatId);
      SocketService.socket.on(ServerStrings.chatDeleted, (id) async {
        await SocketService.hiveService.deleteChat(id);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
