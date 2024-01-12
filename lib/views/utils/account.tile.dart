import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/assets_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import '../../data/models/models.dart';

ListTile accountTile(Account account) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.s4),
    leading: CircleAvatar(
      backgroundImage: AssetImage(account.user.profilePic ?? ImageAssets.image),
    ),
    title: Text(account.user.username!),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: account.isActive,
          onChanged: (value) {
            debugPrint("switched: $value");
            account.isActive = value;
          },
          splashRadius: Spacing.s10,
          trackColor: MaterialStateProperty.resolveWith((states) {
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
