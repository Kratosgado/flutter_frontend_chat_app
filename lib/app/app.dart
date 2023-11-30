import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app_refs.dart';
import 'package:flutter_frontend_chat_app/app/di.dart';
import 'package:flutter_frontend_chat_app/views/splash/splash.dart';
import 'package:get/get.dart';

import '../resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp instance = MyApp._internal();

  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppPreferences appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashView(),
    );
  }
}
