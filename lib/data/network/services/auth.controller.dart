import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/signup_data.dart';
import 'package:flutter_frontend_chat_app/data/models/user_model.dart';
import 'package:flutter_frontend_chat_app/resources/route_manager.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

class AuthController extends GetConnect {
  final _appPreference = instance<AppPreferences>();

  Future<void> signUp({required SignUpData signUpData}) async {
    try {
      final response = await post(
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
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> signIn(SignUpData signUpData) async {
    try {
      Response response = await post(
        ServerStrings.login,
        {"email": signUpData.email, "password": signUpData.password},
      );

      if (response.isOk) {
        await _appPreference.setUserToken(response.body);

        await _appPreference.setIsUserLoggedIn();
        await me();

        Get.offAllNamed(Routes.chatList);
      }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> me() async {
    try {
      Response res = await get(
        ServerStrings.getMe,
        headers: {'Authorization': "Bearer ${await _appPreference.getUserToken()}"},
        decoder: (data) => User.fromMap(data),
      );

      if (res.isOk) {
        await _appPreference.setUserDetails(res.body);
        debugPrint("details saved");
      }
    } catch (err) {
      debugPrint(err.toString());
      Get.snackbar(
        "Error Fetching chats",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    await _appPreference.logout();
    Get.offAllNamed(Routes.loginRoute);
  }
}
