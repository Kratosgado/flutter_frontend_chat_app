// ignore_for_file: constant_identifier_names

import 'package:flutter_frontend_chat_app/data/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_TOKEN = "PREFS_KEY_TOKEN";

class AppPreferences {
  GetStorage localStorage = GetStorage();

  // AppPreferences(this.localStorage);

  Future<void> setUserToken(String token) async {
    localStorage.write(PREFS_KEY_TOKEN, token);
  }

  Future<void> setUserDetails(User currentuser) async {
    localStorage.write('currentUser', currentuser.toMap());
  }

  User getCurrentUser() {
    final userMap = localStorage.read('currentUser');

    return User.fromMap(userMap);
  }

  Future<String> getUserToken() async {
    return localStorage.read(PREFS_KEY_TOKEN) ?? "";
  }

  Future<void> setIsUserLoggedIn() async {
    localStorage.write(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return localStorage.read(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    localStorage.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }
}
