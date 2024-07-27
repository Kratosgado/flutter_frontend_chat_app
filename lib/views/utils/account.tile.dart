import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/auth.controller.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import '../../data/models/models.dart';
import '../../resources/utils.dart';

ListTile accountTile(Account account) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.s4),
    leading: CircleAvatar(
      backgroundImage: MemoryImage(account.user.profilePic != null
          ? TypeDecoder.toBytes(account.user.profilePic!)
          : TypeDecoder.defaultPic),
    ),
    title: Text(account.user.username!),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: account.isActive,
          onChanged: (value) async {
            debugPrint("switched: $value");
            if (value) {
              await AuthController().switchCurrentUser(account);
            }
            account.isActive = value;
          },
          splashRadius: Spacing.s10,
          trackColor: WidgetStateProperty.resolveWith((states) {
            return Colors.teal;
          }),
        ),
        IconButton(
          onPressed: () async {
            await account.delete();
          },
          icon: const Icon(
            Icons.delete,
            size: Spacing.s15,
            color: Colors.teal,
          ),
        )
      ],
    ),
  );
}
