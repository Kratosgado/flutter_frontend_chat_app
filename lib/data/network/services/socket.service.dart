import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/hive.service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../resources/string_manager.dart';
import '../../models/models.dart';
import 'chat.controller.dart';

class SocketService extends GetxService {
  static late final HiveService hiveService;
  final connect = GetConnect();

  // for socket
  static io.Socket socket = io.io(baseUrl);
  static late Account currentAccount;

  static SocketService get to => Get.find();

  Future<void> init() async {
    await hiveService.initDbFuture;
    currentAccount = await hiveService.getCurrentAccount();

    await connectToSocket();

    await ChatController().fetchChats();

    super.onInit();
  }

  Future<void> connectToSocket() async {
    socket = io.io(
      baseUrl,
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

    socket.on(ServerStrings.chatDeleted, (chatId) {
      hiveService.deleteChat(chatId as String);
    });

    socket.onDisconnect((data) => debugPrint("disconnect"));
  }

  @override
  Future<void> onClose() async {
    await hiveService.logout(currentAccount);
    socket.disconnect();
    super.onClose();
  }
}
