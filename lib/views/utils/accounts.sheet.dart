import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/network/services/socket.service.dart';
import '../../resources/values_manager.dart';
import 'account.tile.dart';

Future accountsSheet() => Get.bottomSheet(
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
            future: SocketService.hiveService.getAccounts(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final accounts = snapshots.data!;
              return Column(
                children: accounts.map((account) => accountTile(account)).toList(),
              );
            },
          ),
        ],
      ),
      elevation: Spacing.s10,
    );
