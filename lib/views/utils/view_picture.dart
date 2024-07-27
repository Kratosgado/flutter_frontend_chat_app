import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';

void viewProfileImage(User user) {
  final isCurrentUser = user.id == SocketService.currentAccount.id;

  Get.to(
    () => Hero(
      tag: "profile_pic${user.id}",
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(user.username!),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            Center(
                child: Image.memory(user.profilePic != null
                    ? TypeDecoder.toBytes(user.profilePic!)
                    : TypeDecoder.defaultPic)),
            if (isCurrentUser)
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateColor.resolveWith((states) => Colors.transparent)),
                onPressed: () {},
                child: const Text("change profile picture"),
              ),
          ],
        ),
      ),
    ),
  );
}
