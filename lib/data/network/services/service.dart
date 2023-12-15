import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app/app_refs.dart';
import '../../../app/di.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/utils.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';

class SocketService extends GetxService {

  static final _appPreference = AppPreferences();
  static RxList<Chat> chatList = <Chat>[].obs;
  static Rx<Chat> openedChat = Rx(Chat(id: '', convoName: '', messages: [], users: []));
  final connect = GetConnect();


  late String token;
  static io.Socket socket = io.io(BASEURL);
  static late final User currentUser;


  Future<void> init() async {
    currentUser = _appPreference.getCurrentUser();

    token = await _appPreference.getUserToken();
    debugPrint('token $token');
    await connectToSocket();
    // await fetchChats();

    super.onInit();
  }

  static Future<void> connectToSocket() async {
    socket = io.io(
      BASEURL,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer ${await _appPreference.getUserToken()}"})
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
        debugPrint("chat created: ${data["id"]}");
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
  
}
