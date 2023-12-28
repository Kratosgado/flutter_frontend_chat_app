import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/message_model.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

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
          color: isCurrentUser ? Colors.blue : Colors.pink,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.pictureId != null) Image.network(message.picture!.url),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 4.0),
              Text(
                message.content,
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

  // Future<void> selectImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     selectedImage = File(pickedFile.path);
  //   }
  // }