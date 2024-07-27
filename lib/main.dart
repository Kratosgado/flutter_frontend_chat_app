import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/network/services/hive.service.dart';
import 'data/network/services/socket.service.dart';
// import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await initAppModule();
  await TypeDecoder.setDefaultPic();

  SocketService.hiveService = HiveService();
  await SocketService.hiveService.initDbFuture;
  runApp(SafeArea(child: MyApp()));
}
