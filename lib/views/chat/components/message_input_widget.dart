import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:get/get.dart';

import '../../utils/select_image.dart';

class MessageInputWidget extends StatelessWidget {
  final String chatId;
  MessageInputWidget({super.key, required this.chatId});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Value<Rx<File>> selectedImage = File("").obs.reactive;

    selectedImage.change(selectedImage.value, status: RxStatus.empty());

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            selectedImage.obx(
              (state) {
                return Container(
                  height: 150, // Set the desired height of the image preview
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Image.file(state!.value),
                );
              },
              onEmpty: const SizedBox(),
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
                                selectedImage.value?.value = image;
                                selectedImage.change(selectedImage.value,
                                    status: RxStatus.success());
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions),
                            color: Colors.yellow,
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
                          onPressed: () async {
                            final text = messageController.text.trim();

                            // if (text.isNotEmpty || selectedImage != null) {
                            // Upload the image to Firebase Storage if selected
                            String? imageUrl;
                            // if (selectedImage != null) {
                            //   imageUrl = await uploadImage(selectedImage!);
                            // }

                            // await widget.chatService.sendMessage(widget.conversation, message);

                            // Clear the selected image and text input
                            // selectedImage = null;
                            // textEditingController.clear();
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
