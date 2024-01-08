import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import '../../../data/models/models.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final currentUser = SocketService.currentUser;
    final isCurrentUser = message.senderId == currentUser.id;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.s8),
        margin: const EdgeInsets.symmetric(vertical: Spacing.s2, horizontal: Spacing.s8),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue.shade700 : Colors.teal.shade300,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.picture != null) Image.network(message.picture!),
            if (message.text.isNotEmpty) ...[
              const SizedBox(height: 4.0),
              Text(
                message.text,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}