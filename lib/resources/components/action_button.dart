import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/styles_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:get/get.dart';

Widget actionButton(VoidCallback onTap) {
  return InkResponse(
    onTap: () {},
    child: Container(
      width: Get.width * 0.5,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: Spacing.s16, horizontal: Spacing.s40),
      decoration: StyleManager.boxDecoration.copyWith(),
      child: const Icon(
        Icons.save,
        color: Colors.white,
        size: 15,
        semanticLabel: "Sign in",
      ),
    ),
  );
}
