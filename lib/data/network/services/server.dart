// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

class ServerService extends GetConnect {
  final _appPreference = instance<AppPreferences>();

  Future<void> signUp(String email, String username, String password) async {
    await post(
      ServerStrings.signup,
      {"username": username, "email": email, "password": password},
    ).then((value) async => await signIn(email, password)).catchError((err) {
      Get.dialog(Text(err), barrierColor: ColorManager.error);
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      Response response = await post(
        ServerStrings.signin,
        {"email": email, "password": password},
      );
      _appPreference.setUserTokenn(response.body);
    } catch (err) {
      Get.dialog(Text(err.toString()), barrierColor: ColorManager.error);
    }
  }
}
