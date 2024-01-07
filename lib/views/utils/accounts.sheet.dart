import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/network/services/service.dart';
import '../../resources/values_manager.dart';
import 'account.tile.dart';

final accountsSheet = Get.bottomSheet(
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
      FutureBuilder(
        future: SocketService.isarService.getAccounts(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final accounts = snapshots.data!;
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) => accountTile(accounts[index]),
          );
        },
      ),
    ],
  ),
  elevation: Spacing.s10,
);
