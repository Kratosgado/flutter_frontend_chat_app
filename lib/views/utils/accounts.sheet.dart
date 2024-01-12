import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/network/services/socket.service.dart';
import '../../resources/values_manager.dart';
import 'account.tile.dart';

Future<Column?> accountsSheet() {
  final accounts = SocketService.hiveService.getAccounts();
  debugPrint("accounts: ${accounts.length}");
  return Get.bottomSheet<Column>(
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 5,
          width: Spacing.s60,
          margin: const EdgeInsets.all(Spacing.s4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.teal,
          ),
        ),
        Column(
          children: accounts.map((account) => accountTile(account)).toList(),
        ),
      ],
    ),
    elevation: Spacing.s10,
  );
}
