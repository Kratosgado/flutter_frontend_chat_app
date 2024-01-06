import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app.dart';
import 'package:isar/isar.dart';

// import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Isar.initializeIsarCore();
  // await initAppModule();
  runApp(SafeArea(child: MyApp()));
}
