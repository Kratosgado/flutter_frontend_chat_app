import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app_refs.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
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
  AppPreferences appPreferences = AppPreferences();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Chat app',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      useInheritedMediaQuery: true,
      theme: getApplicationTheme(),
      initialRoute: Routes.splashRoute,
      getPages: getRoutes(),
    );
  }
}
