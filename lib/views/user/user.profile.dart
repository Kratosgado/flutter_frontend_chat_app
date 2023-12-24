import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:flutter_frontend_chat_app/resources/assets_manager.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/views/utils/view_picture.dart';
import 'package:get/get.dart';

import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = SocketService.currentUser;
    final profilePic = currentUser.profilePic ?? ImageAssets.image;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        // backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.s12),
          gradient: LinearGradient(
            colors: [ColorManager.topColor, ColorManager.bottomColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => viewProfileImage(currentUser),
                child: Container(
                  height: Spacing.s120,
                  // padding: const EdgeInsets.all(Spacing.s5),
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: StyleManager.boxDecoration.copyWith(
                    shape: BoxShape.circle,
                    borderRadius: null,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black,
                        blurRadius: Spacing.s4,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Hero(
                    tag: 'profile_pic${currentUser.id}',
                    child: Image.asset(profilePic),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
