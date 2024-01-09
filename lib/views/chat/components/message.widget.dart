import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import '../../../data/models/models.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.senderId == SocketService.currentAccount.id;

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
            if (message.picture != null) Image.asset(message.picture!),
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
            // switch (message.status) {
            //   MessageStatus.SENDING => const Icon(Icons.lock_clock),
            //   MessageStatus.SENT => const Icon(FontAwesomeIcons.clock),
            //   MessageStatus.DELIVERED => const Icon(FontAwesomeIcons.noteSticky),
            //   MessageStatus.SEEN => const Icon(Icons.delivery_dining),
            // },
            Icon(
              switch (message.status) {
                MessageStatus.SENDING => Icons.lock_clock,
                MessageStatus.SENT => Icons.waves_rounded,
                MessageStatus.DELIVERED => Icons.add_location_alt,
                MessageStatus.SEEN => Icons.remove_red_eye,
              },
              size: 10,
            ),
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}
