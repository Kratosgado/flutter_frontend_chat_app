import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app/app_refs.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';

class SocketService extends GetxService {
  static final appPreference = AppPreferences();
  static RxList<Chat> chatList = <Chat>[].obs;
  static Rx<Chat> openedChat = Rx(Chat(id: '', convoName: '', messages: [], users: []));
  final connect = GetConnect();

  static late String token;
  static io.Socket socket = io.io(BASEURL);
  static late User currentUser;

  Future<void> init() async {
    currentUser = await appPreference.getCurrentUser();

    token = await appPreference.getUserToken();
    await connectToSocket();
    await ChatController.fetchChats();

    super.onInit();
  }

  static Future<void> connectToSocket() async {
    socket = io.io(
      BASEURL,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer $token"})
          .setQuery({"userId": currentUser.id})
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

    socket.onError((data) => {
          debugPrint(data.toString()),
        });

    socket.on(ServerStrings.newMessage, (data) {
      try {
        // fetchChats();
        final message = Message.fromMap(data);
        openedChat.value.messages.add(message);
        openedChat.refresh();
        // ChatController.findOneChat(message.chatId);
        debugPrint(openedChat.value.messages.last.content);

        Get.snackbar("Chat App", message.content);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.on(ServerStrings.chatCreated, (data) {
      try {
        debugPrint("chat created: ${data.toString()}");
        final createdChat = Chat.fromMap(data);
        chatList.addIf(chatList.map((element) => element.id != createdChat.id), createdChat);
        // Get.snackbar("New Chat created", data[""]);
        Get.offNamed(Routes.chat, arguments: createdChat.id);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket.on(ServerStrings.returningChats, (data) async {
      try {
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
      } catch (e) {
        debugPrint(e.toString());
      }
    });
    socket.on(ServerStrings.returningChat, (data) {
      try {
        final chat = Chat.fromMap(data);
        debugPrint("recieved chat id: ${chat.id}");
        openedChat.value = chat;
      } catch (err) {
        debugPrint(err.toString());
        Get.snackbar("Chat recieving error", err.toString());
      }
    });

    socket.on(ServerStrings.chatDeleted, (chatId) {
      chatList.removeWhere((element) => element.id == chatId as String);
    });

    socket.onDisconnect((data) => debugPrint("disconnect"));
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
