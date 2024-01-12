import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/hive.service.dart';
import 'package:get/get.dart';

import '../data/network/services/socket.service.dart';

Future<void> initService() async {
  debugPrint("starting services");
  await Get.put(SocketService()).init();
}
