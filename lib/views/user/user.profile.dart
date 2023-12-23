import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';

import '../../resources/values_manager.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = SocketService.currentUser;
    final profilePic = currentUser.profilePic != null;

    final imageData = profilePic ? base64Decode(currentUser.profilePic!) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(Spacing.s5),
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: Spacing.s4,
                    offset: Offset(2, 2),
                  )
                ]),
                child: Hero(
                  tag: 'profile_pic_tag',
                  child: profilePic
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(imageData!),
                        )
                      : const Icon(
                          Icons.person_2_rounded,
                          color: Colors.blue,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
