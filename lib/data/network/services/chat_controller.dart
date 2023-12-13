import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../app/app_refs.dart';
import '../../../app/di.dart';
import '../../../resources/string_manager.dart';
import '../../models/chat_model.dart';

class ChatController extends GetxController {
  final _appPreference = instance<AppPreferences>();
  final RxList<Chat> chatList = <Chat>[].obs;
  final Rx<Chat> openedChat = Rx(Chat(id: '', convoName: '', messages: [], users: []));
  final connect = GetConnect();

  late String token;
  late io.Socket socket = io.io(BASEURL);

  @override
  void onInit() async {
    token = await _appPreference.getUserToken();
    await connectToSocket();
    await fetchChats();

    super.onInit();
  }

  Future<void> connectToSocket() async {
    socket = io.io(
      BASEURL,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer $token"})
          .setQuery({"userId": _appPreference.getCurrentUser().id})
          .enableReconnection()
          .enableAutoConnect()
          .enableForceNewConnection()
          .enableForceNew()
          .build(),
    );
    socket.connect();

    socket.onConnect((data) {
      debugPrint("connected ${socket.id}");
    });

    socket.on(ServerStrings.newMessage, (data) {
      try {
        // fetchChats();
        Get.snackbar("Chat App", data['content']);
        debugPrint(data.toString());
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.on(ServerStrings.chatCreated, (data) {
      try {
        final createdChat = Chat.fromMap(data);
        chatList.add(createdChat);
        // Get.snackbar("New Chat created", data[""]);
        Get.offNamed(Routes.chat, arguments: createdChat.id);
        debugPrint(data.toString());
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.on(ServerStrings.returningChats, (data) {
      try {
        final source = data.map((chat) => Chat.fromMap(chat)).toList();
        debugPrint("chats recieved: ${source.length}");

        chatList.value = TypeDecoder.fromMapList(source);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
    socket.on(ServerStrings.returningChat, (data) {
      try {
        debugPrint("recieved chat: ${data["id"]}");
        final chat = Chat.fromMap(data);

        debugPrint("recieved chat id: ${chat.id}");
        openedChat.value = chat;
      } catch (err) {
        debugPrint(err.toString());
        Get.snackbar("Chat recieving error", err.toString());
      }
    });

    socket.onDisconnect((data) => debugPrint("disconnect"));
  }

  Future<void> fetchChats() async {
    try {
      debugPrint("fetching chats of user");
      socket.emit(ServerStrings.getChats);
      // var response = await connect.get(
      //   ServerStrings.getChats,
      //   headers: {"Authorization": "Bearer ${await _appPreference.getUserToken()}"},
      //   decoder: (data) => data.map((chat) => Chat.fromMap(chat)).toList(),
      // );
      // if (response.isOk) {
      //   chatList.value = TypeDecoder.fromMapList<Chat>(response.body);
      //   debugPrint("chats retrieved: ${chatList.length}");
      // }
      // if (response.hasError) {
      //   debugPrint("server error: ${response.body}");

      //   Get.snackbar(response.statusCode.toString(), response.statusText!);
      // }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar("Error Fetching chats", err.toString());
    }
  }

  // send message to recieve chats
  void findOneChat(chatId) {
    debugPrint("finding chat with id: $chatId");
    socket.emit(ServerStrings.findOneChat, chatId);
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
      socket.emit('createChat', {
        "userIds": [userId]
      });
      // Response res = await connect.post(ServerStrings.createChat, {
      //   "userIds": [userId]
      // }, headers: {
      //   "Authorization": "Bearer ${await _appPreference.getUserToken()}"
      // });

      // if (res.isOk) {
      //   Get.offNamed(Routes.chat);
      // }
      // if (res.hasError) {
      //   debugPrint(res.statusText);
      //   Get.snackbar(res.status.toString(), res.statusText!);
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    debugPrint("disconnecting");
    socket.disconnect();
    super.onClose();
  }
}
