import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../app/app_refs.dart';
import '../../../app/di.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/chat_model.dart';

class ChatController extends GetxController {
  final _appPreference = instance<AppPreferences>();
  final chatList = RxList<Chat>();
  final connect = GetConnect();
  late IO.Socket socket;

  @override
  void onInit() async {
    connectToSocket();
    await fetchChats();
    super.onInit();
  }

  void connectToSocket() {
    socket = IO.io(
      BASEURL,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    socket.id = 'replacedIdsdfjosdijf';
    // socket.connect();
    socket.onConnect((data) {
      debugPrint("connect scopt");
    });

    socket.on('newMessage', (data) {
      try {
        fetchChats();
        Get.snackbar("Chat App", data['content']);
        debugPrint(data.toString());
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.onDisconnect((data) => debugPrint("disconnect"));
  }

  Future<void> fetchChats() async {
    try {
      ServerController().me();
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

  void sendMessage(String content, String chatId) async {
    try {
      Response res = await connect.post(
          ServerStrings.sendMessage, {"content": content, "chatId": chatId},
          headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"});
      if (res.isOk) {
        debugPrint("message sent: $content");
      }
      if (res.hasError) {
        debugPrint("server error: ${res.body}");

        Get.snackbar(res.statusCode.toString(), res.statusText!);
      }
    } catch (e) {
      debugPrint(3.toString());
      Get.snackbar("Error Fetching chats", e.toString());
    }
  }

  Future<void> createChat(String userId) async {
    try {
      Response res = await connect.post(ServerStrings.createChat, {
        "userIds": [userId]
      }, headers: {
        "Authorization": "Bearer ${await _appPreference.getUserToken()}"
      });

      if (res.isOk) {
        Get.offNamed(Routes.chat);
      }
      if (res.hasError) {
        debugPrint(res.statusText);
        Get.snackbar(res.status.toString(), res.statusText!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getChat(String id) async {
    Response response = await connect.get("${ServerStrings.getChat}$id",
        headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"});
    if (response.isOk) {
      Get.snackbar(response.statusCode.toString(), response.statusText.toString());
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    socket.disconnect();
    super.onClose();
  }
}
