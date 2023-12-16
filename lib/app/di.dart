import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/network/services/service.dart';

Future<void> initService() async {
  debugPrint("starting services");
  await GetStorage().initStorage;

  await Get.put(SocketService()).init();
}