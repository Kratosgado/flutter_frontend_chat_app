import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await initAppModule();
  runApp(SafeArea(child: MyApp()));
}
