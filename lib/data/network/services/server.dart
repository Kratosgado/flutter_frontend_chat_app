import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

class ServerController extends GetxController {
  final _appPreference = instance<AppPreferences>();
  final connect = GetConnect();

  Future<void> signUp({required SignUpData signUpData}) async {
    try {
      final response = await connect.post(
        ServerStrings.signup,
        {
          "username": signUpData.username,
          "email": signUpData.email,
          "password": signUpData.password
        },
      );
      if (response.isOk) {
        await signIn(signUpData);
      }
      if (response.hasError) {
        debugPrint("server error: $response");
        const AlertDialog(
          actions: [ActionChip.elevated(label: Text('ok'))],
          content: AboutDialog(),
        );
        Get.snackbar(response.statusCode.toString(), response.statusText!);
      }
    } catch (e) {
      const AlertDialog(
        actions: [ActionChip.elevated(label: Text('ok'))],
      );
    }
  }

  Future<void> signIn(SignUpData signUpData) async {
    try {
      Response response = await connect.post(
        ServerStrings.login,
        {"email": signUpData.email, "password": signUpData.password},
      );
      await _appPreference.setUserTokenn(response.body);

      if (response.isOk) {
        await _appPreference.setIsUserLoggedIn();

        Get.offAllNamed(Routes.chatList);
      }
    } catch (err) {
      Get.dialog(Text(err.toString()), barrierColor: ColorManager.error);
    }
  }

  Future<void> logout() async {
    await _appPreference.logout();
    Get.offNamed(Routes.loginRoute);
  }
}
