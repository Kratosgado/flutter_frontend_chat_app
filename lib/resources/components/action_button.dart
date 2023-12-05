import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/styles_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

Widget actionButton(VoidCallback onTap) {
  return InkResponse(
    
    onTap: () {},
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: Spacing.s16, horizontal: Spacing.s40),
      decoration: StyleManager.boxDecoration,
      child: const Icon(
        Icons.login,
        color: Colors.white,
        size: 15,
        semanticLabel: "Sign in",
      ),
    ),
  );
}
