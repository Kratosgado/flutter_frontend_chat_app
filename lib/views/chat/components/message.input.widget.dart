import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/models.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:get/get.dart';

import '../../../resources/utils.dart';
import '../../utils/select_image.dart';

class MessageInputWidget extends StatelessWidget {
  final String chatId;
  MessageInputWidget({super.key, required this.chatId});

  final messageController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final selectedImage = Rx<File>(File(""));
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Obx(
              () {
                if (selectedImage.value.path.isNotEmpty) {
                  return Container(
                    height: 150, // Set the desired height of the image preview
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(selectedImage.value),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            color: Colors.teal,
                            icon: const Icon(Icons.image),
                            onPressed: () async {
                              File? image = await selectImage();
                              if (image != null) {
                                selectedImage.value = image;
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions),
                            color: Colors.teal,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      hintText: 'Type a message...',
                      // enabled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(80),
                        borderSide: BorderSide(color: Colors.teal.shade300),
                      ),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded),
                          color: Colors.teal,
                          onPressed: () {
                            final picBase64 = selectedImage.value.path.isNotEmpty
                                ? TypeDecoder.imageToBase64(selectedImage.value)
                                : null;
                            final message = Message()
                              ..chatId = chatId
                              ..picture = picBase64
                              ..senderId = SocketService.currentAccount.id
                              ..text = messageController.text;
                            SocketService.hiveService.sendMessage(message);

                            messageController.clear();
                            selectedImage.value = File("");
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
