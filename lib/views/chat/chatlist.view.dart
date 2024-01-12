import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/hive.service.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/chat.tile.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/leading.tile.dart';
import 'package:flutter_frontend_chat_app/views/utils/accounts.sheet.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/models.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = SocketService.currentAccount.user;

    return Scaffold(
      appBar: AppBar(
        leading: leadingTile(),
        title: Text(
          "Hello ${currentUser.username}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              accountsSheet();
            },
            icon: const Icon(Icons.opacity_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.s12),
        child: ValueListenableBuilder(
            valueListenable: Hive.box<Chat>(HiveService.chatsBoxName).listenable(),
            builder: (context, box, _) {
              var chats = box.values
                  .where((chat) => chat.users.any((user) => user.id == currentUser.id))
                  .toList();

              if (chats.isEmpty) {
                return const Center(
                  child: Text("No conversation yet"),
                );
              }

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return Column(
                    children: [
                      chatTile(chat),
                      const Divider(
                        height: 0.1,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ],
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.userList),
        tooltip: "Add new Chat",
        mini: true,
        enableFeedback: true,
        shape: const StadiumBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
