import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:get/get.dart';

import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';

GestureDetector leadingTile() {
  final profilePic = SocketService.currentAccount.user.profilePic;
  return GestureDetector(
    onTap: () => Get.toNamed(Routes.userProfile),
    child: Container(
      padding: const EdgeInsets.all(Spacing.s2),
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
      child: CircleAvatar(
        backgroundImage: MemoryImage(profilePic != null ? TypeDecoder.toBytes(profilePic) : TypeDecoder.defaultPic),
      ),
    ),
  );
}
