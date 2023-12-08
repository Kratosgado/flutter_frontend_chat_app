import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/chat_model.dart';

import 'chat_view.dart';

OpenContainer chatTile(Chat chat) {
  final profile = chat.users.first.profilePic != null;
  return OpenContainer(
    transitionDuration: const Duration(milliseconds: 500),
    closedBuilder: (ctx, action) => ListTile(
      dense: true,
      tileColor: Colors.blueAccent.shade200,
      shape: const StadiumBorder(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      leading: GestureDetector(
        onTap: () {},
        child: Hero(
            tag: 'profile_pic_tag_${chat.id}',
            child: profile
                ? CircleAvatar(
                    backgroundImage: AssetImage(chat.users.first.profilePic!),
                  )
                : const Icon(Icons.person_4)),
      ),

      title: Text(
        chat.users.first.username!,
      ),
      subtitle: Text(chat.messages.isEmpty ? "No message" : chat.messages.first.content),
      // onTap: () => Navigator.of(context).pushNamed(ChatView.routename, arguments: chat),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // TODO: Delete Chat
          // chatService.deleteConversation(chat);
        },
      ),
    ),
    openBuilder: (context, action) => ChatView(
      chatId: chat.id,
    ),
  );
}
