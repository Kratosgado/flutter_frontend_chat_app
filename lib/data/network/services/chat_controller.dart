import 'package:flutter/material.dart';
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
    debugPrint("connecting to socket");
    socket = IO.io(BASEURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on('connect', (_) {
      debugPrint("connected to socket");
    });

    socket.on('newMessage', (data) {
      debugPrint(data);
    });

    socket.onDisconnect((data) => debugPrint("disconnect"));
  }

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

  void sendMessage(String content, String chatId) async {
    try {
      Response res = await connect.post(
          ServerStrings.sendMessage, {"content": content, "chatId": chatId},
          headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"});
      if (res.isOk) {
        Get.snackbar("message sent", "lkfdj");
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
