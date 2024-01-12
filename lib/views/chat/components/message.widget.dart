import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import '../../../data/models/models.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.senderId == SocketService.currentAccount.id;

    return isCurrentUser ? senderBubble() : recieverBubble();
  }

  ChatBubble senderBubble() => ChatBubble(
        alignment: Alignment.centerRight,
        clipper: ChatBubbleClipper10(type: BubbleType.sendBubble),
        backGroundColor: Colors.blue.shade700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.picture != null) Image.asset(message.picture!),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    softWrap: true,
                  ),
                const SizedBox(
                  width: Spacing.s4,
                ),
                Icon(
                  switch (message.status) {
                    MessageStatus.SENDING => Icons.lock_clock,
                    MessageStatus.SENT => Icons.waves_rounded,
                    MessageStatus.DELIVERED => Icons.add_location_alt,
                    MessageStatus.SEEN => Icons.remove_red_eye,
                  },
                  size: 10,
                ),
              ],
            ),
          ],
        ),
      );

  ChatBubble recieverBubble() => ChatBubble(
        alignment: Alignment.centerLeft,
        clipper: ChatBubbleClipper10(type: BubbleType.receiverBubble),
        backGroundColor: Colors.teal.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.picture != null) Image.asset(message.picture!),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                const SizedBox(
                  width: Spacing.s4,
                ),
                Icon(
                  switch (message.status) {
                    MessageStatus.SENDING => Icons.lock_clock,
                    MessageStatus.SENT => Icons.waves_rounded,
                    MessageStatus.DELIVERED => Icons.add_location_alt,
                    MessageStatus.SEEN => Icons.remove_red_eye,
                  },
                  size: 10,
                ),
              ],
            ),
          ],
        ),
      );
}

// decoration: BoxDecoration(
      //   color: isCurrentUser ? Colors.blue.shade700 : Colors.teal.shade300,
      //   borderRadius: BorderRadius.circular(12.0),
      // ),