// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

class ServerService extends GetConnect {
  final _appPreference = instance<AppPreferences>();

  Future<void> signUp({required SignUpData signUpData}) async {
    await post(
      ServerStrings.signup,
      {"username": signUpData.username, "email": signUpData.email, "password": signUpData.password},
    ).then(
      (value) async => await signIn(signUpData).catchError(
        (err) {
          Get.dialog(Text(err.toString()), barrierColor: ColorManager.error);
        },
      ).catchError(
        (onError) {
          Get.defaultDialog();
        },
      ),
    );
  }

  Future<void> signIn(SignUpData signUpData) async {
    try {
      Response response = await post(
        ServerStrings.signin,
        {"email": signUpData.email, "password": signUpData.password},
      );
      _appPreference.setUserTokenn(response.body);
    } catch (err) {
      Get.dialog(Text(err.toString()), barrierColor: ColorManager.error);
    }
  }
}
