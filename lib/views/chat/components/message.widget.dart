import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/chat/components/message.status_icon.dart';
import 'package:get/get.dart';

import '../../../data/models/models.dart';

class MessageWidget extends StatelessWidget {
  final Rx<Message> message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.value.senderId == SocketService.currentAccount.id;
    return isCurrentUser ? senderBubble() : recieverBubble();
  }

  ChatBubble senderBubble() => ChatBubble(
        alignment: Alignment.centerRight,
        clipper: ChatBubbleClipper10(type: BubbleType.sendBubble),
        backGroundColor: Colors.blue.shade700,
        child: GestureDetector(
          onLongPress: () {
            debugPrint("long Pressed");
          },
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.value.picture != null) Image.memory(TypeDecoder.toBytes(message.value.picture!)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message.value.text.isNotEmpty)
                        Text(
                          message.value.text,
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
                      messageStatusIcon(message.value.status)
                    ],
                  ),
                ],
              )),
        ),
      );

  ChatBubble recieverBubble() => ChatBubble(
        alignment: Alignment.centerLeft,
        clipper: ChatBubbleClipper10(type: BubbleType.receiverBubble),
        backGroundColor: Colors.teal.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.value.picture != null)
              Image.memory(
                TypeDecoder.toBytes(message.value.picture!),
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: Spacing.s10),
                    child: child,
                  );
                },
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.value.text.isNotEmpty)
                  Text(
                    message.value.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                const SizedBox(
                  width: Spacing.s4,
                ),
                messageStatusIcon(message.value.status),
              ],
            ),
          ],
        ),
      );
}
