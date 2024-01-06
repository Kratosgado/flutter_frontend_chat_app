import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/assets_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

import '../../data/models/models.dart';

Widget accountTile(User user) {
  return ListTile(
    dense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.s4),
    leading: CircleAvatar(
      backgroundImage: AssetImage(user.profilePic ?? ImageAssets.image),
    ),
    title: Text(user.username),
    trailing: Switch(
      value: true,
      onChanged: (value) {},
      splashRadius: Spacing.s10,
      trackColor: MaterialStateProperty.resolveWith((states) {
        return Colors.teal;
      }),
    ),
  );
}
