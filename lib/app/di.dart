import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/network/services/socket.service.dart';

Future<void> initService() async {
  debugPrint("starting services");
  await Get.put(SocketService()).init();
}
