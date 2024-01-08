import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/isar_service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app/app_refs.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../models/models.dart';

class SocketService extends GetxService {
  static final isarService = IsarService();
  final connect = GetConnect();

  // for socket
  static io.Socket socket = io.io(BASEURL);
  static late Account currentAccount;

  static SocketService get to => Get.find();

  Future<void> init() async {
    currentAccount = await isarService.getCurrentAccount();

    await connectToSocket();
    await ChatController.to.fetchChats();

    super.onInit();
  }

  Future<void> connectToSocket() async {
    socket = io.io(
      BASEURL,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer ${currentAccount.token}"})
          .setQuery({"userId": currentAccount.id})
          .enableReconnection()
          .enableAutoConnect()
          .enableForceNewConnection()
          .enableForceNew()
          .build(),
    );
    socket.connect();

    socket.onConnect((data) {
      debugPrint("connected ${socket.id}");
      // socket.emit("ready");
    });

    socket.onError((data) => {
          debugPrint(data.toString()),
        });

    socket.on(ServerStrings.newMessage, (data) {
      try {
        // fetchChats();
        final message = Message.fromJson(data);
        // ChatController.findOneChat(message.chatId);

        socket.emit(ServerStrings.deleteSocketMessage, message.id);
        Get.snackbar("Chat App", message.text);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.on(ServerStrings.chatCreated, (data) {
      try {
        debugPrint("chat created: ${data.toString()}");
        final createdChat = Chat.fromJson(data);
        // Get.snackbar("New Chat created", data[""]);
        Get.offNamed(Routes.chat, arguments: createdChat.id);
        socket.emit(ServerStrings.deleteSocketMessage, createdChat.id);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.on(ServerStrings.returningChat, (data) {
      try {
        final chat = Chat.fromJson(data);
        debugPrint("recieved chat id: ${chat.id}");
        isarService.updateChat(chat);
      } catch (err) {
        debugPrint(err.toString());
        Get.snackbar("Chat recieving error", err.toString());
      }
    });

    socket.on(ServerStrings.chatDeleted, (chatId) {
      isarService.deleteChat(chatId as String);
    });

    socket.onDisconnect((data) => debugPrint("disconnect"));
  }

  @override
  Future<void> onClose() async {
    await isarService.logout(currentAccount.id);
    socket.disconnect();
    super.onClose();
  }
}
