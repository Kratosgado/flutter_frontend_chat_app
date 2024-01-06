import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../resources/assets_manager.dart';

void viewProfileImage(User user) {
  final isCurrentUser = user.id == SocketService.currentUser.id;

  Get.to(
    () => Hero(
      tag: "profile_pic${user.id}",
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(user.username),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            Center(child: Image.asset(user.profilePic ?? ImageAssets.image)),
            if (isCurrentUser)
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.transparent)),
                onPressed: () {},
                child: const Text("change profile picture"),
              ),
          ],
        ),
      ),
    ),
  );
}
