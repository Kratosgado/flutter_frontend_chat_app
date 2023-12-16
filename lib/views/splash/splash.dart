import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/app/app_refs.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:get/get.dart';

import '../../app/di.dart';
import 'animated_container.dart';
import 'loading_text.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final appPreference = AppPreferences();
  Timer? timer;

  startDelay() {
    timer = Timer(const Duration(seconds: 3), goNext);
  }

  goNext() async {
    appPreference.isUserLoggedIn().then((isUserLoggedIn) async => {
          if (isUserLoggedIn)
            {
              await initService(),
              Get.offNamed(Routes.chatList),
            }
          else
            {
              Get.offNamed(Routes.loginRoute),
            }
        });
  }

  @override
  void initState() {
    super.initState();
    startDelay();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedImageContainer(width: 100, height: 100),
            SizedBox(height: Spacing.s20),
            LoadingText(),
          ],
        ),
      ),
    );
  }
}
