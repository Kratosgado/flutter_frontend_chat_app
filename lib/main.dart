import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app.dart';
import 'package:flutter_frontend_chat_app/app/di.dart';
import 'package:flutter_frontend_chat_app/resources/theme_manager.dart';
import 'package:flutter_frontend_chat_app/views/auth/signup.dart';
// import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  runApp(MyApp());
}
