import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:flutter_frontend_chat_app/resources/assets_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

ListTile accountTile(Account account) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.s4),
    leading: CircleAvatar(
      backgroundImage: AssetImage(account.profilePic ?? ImageAssets.image),
    ),
    title: Text(account.username!),
    trailing: Switch(
      value: account.isActive!,
      onChanged: (value) {},
      splashRadius: Spacing.s10,
      trackColor: MaterialStateProperty.resolveWith((states) {
        return Colors.teal;
      }),
    ),
  );
}
