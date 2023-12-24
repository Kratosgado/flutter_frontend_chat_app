
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../resources/assets_manager.dart';

void viewProfileImage(User user) {

  Get.to(
    () => Hero(
      tag: "profile_pic${user.id}",
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(user.username!),
        ),
        body: Center(
          child: Image.asset(user.profilePic ?? ImageAssets.image)
              
        ),
      ),
    ),
  );
}
