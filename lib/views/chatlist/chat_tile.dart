
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/chat_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/resources/assets_manager.dart';
import 'package:flutter_frontend_chat_app/resources/styles_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:get/get.dart';

import 'chat_view.dart';

OpenContainer chatTile(Chat chat) {
  final notCurrentUser =  chat.users.firstWhereOrNull((user) => user.id != SocketService.currentUser.id);
  final profilePic =
     notCurrentUser ?.profilePic ?? ImageAssets.image;
  debugPrint(profilePic);

  final Color topColor = Colors.blue.shade700;
  final Color bottomColor = Colors.teal.shade400;
  return OpenContainer(
    transitionDuration: const Duration(milliseconds: 500),
    closedColor: Colors.transparent,
    // middleColor: Colors.blue.shade700,
    transitionType: ContainerTransitionType.fadeThrough,
    closedBuilder: (ctx, action) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Spacing.s12),
        gradient: LinearGradient(
          colors: [topColor, bottomColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListTile(
        // onTap: () {},
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        leading: GestureDetector(
          onTap: () => viewProfileImage(chat),
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(left: Spacing.s5),
            decoration: StyleManager.boxDecoration.copyWith(
              shape: BoxShape.circle,
              borderRadius: null,
              boxShadow: [
                const BoxShadow(
                  color: Colors.black,
                  blurRadius: Spacing.s4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: Hero(
              tag: 'profile_pic${chat.id}',
              child: CircleAvatar(
                      backgroundImage: AssetImage(profilePic),
                    )
            ),
          ),
        ),
        title: Text(
          chat.convoName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 2, offset: Offset(1, 1))],
          ),
        ),
        subtitle: Text(
          chat.messages.isEmpty ? "No message" : chat.messages.first.content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            size: 10,
          ),
          onPressed: () {
            ChatController.deleteChat(chat.id);
            // chatService.deleteConversation(chat);
          },
        ),
      ),
    ),
    openBuilder: (context, action) => ChatView(
      chatId: chat.id,
    ),
  );
}

void viewProfileImage(Chat chat) {
  final user = chat.users.firstWhere((user) => user.id != SocketService.currentUser.id);
  Get.to(
    () => Hero(
      tag: "profile_pic${chat.id}",
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(user.username!),
        ),
        body: Center(
          child: user.profilePic != null
              ? Image.asset(user.profilePic!)
              : Image.asset(ImageAssets.image),
        ),
      ),
    ),
  );
}
