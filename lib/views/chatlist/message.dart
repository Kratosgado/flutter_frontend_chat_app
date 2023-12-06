import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Text(message.content),
    );
  }
}
