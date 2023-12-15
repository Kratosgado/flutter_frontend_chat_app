import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app.dart';
import 'package:flutter_frontend_chat_app/app/di.dart';
import 'package:flutter_frontend_chat_app/data/network/services/service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initAppModule();
  await initService();
  runApp(MyApp());
}

Future<void> initService() async {
  debugPrint("starting services");
  await GetStorage().initStorage;

  await Get.put(SocketService()).init();
}
