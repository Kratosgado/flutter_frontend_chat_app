import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

Widget actionButton(VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: Spacing.s16, horizontal: Spacing.s40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.blue, offset: Offset(0, -1), blurRadius: 5),
          BoxShadow(color: Colors.red, offset: Offset(0, 1), blurRadius: 5),
        ],
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
          Colors.pink,
          Colors.blue.shade900,
        ]),
      ),
      child: const Icon(
        Icons.login,
        color: Colors.white,
        size: 15,
        semanticLabel: "Sign in",
      ),
    ),
  );
}
