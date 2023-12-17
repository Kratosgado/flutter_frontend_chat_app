import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/chat_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import 'chat_view.dart';

OpenContainer chatTile(Chat chat) {
  final profile = chat.users.first.profilePic != null;
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
        // tileColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(Spacing.s5),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: Spacing.s4,
                offset: Offset(2, 2),
              )
            ]),
            child: Hero(
                tag: 'profile_pic_tag_${chat.id}',
                child: profile
                    ? CircleAvatar(
                        backgroundImage: AssetImage(chat.users.first.profilePic!),
                      )
                    : const Icon(
                        Icons.person_2_rounded,
                        color: Colors.blue,
                      )),
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
