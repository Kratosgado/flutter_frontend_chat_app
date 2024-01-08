// ignore_for_file: constant_identifier_names

import 'package:get_storage/get_storage.dart';

import '../data/models/models.dart';

const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_TOKEN = "PREFS_KEY_TOKEN";

class AppPreferences {
  GetStorage localStorage = GetStorage();

  // AppPreferences(this.localStorage);

  Future<void> setUserToken(String token) async {
    localStorage.write(PREFS_KEY_TOKEN, token);
  }

  Future<void> setCurrentUser(User currentuser) async {
    localStorage.write('currentUser', currentuser.toJson());
  }

  Future<User> getCurrentUser() async {
    final userMap = await localStorage.read('currentUser');

    return User.fromJson(userMap);
  }

  Future<String> getUserToken() async {
    return localStorage.read(PREFS_KEY_TOKEN) ?? "";
  }

  Future<void> logout() async {
    localStorage.remove(PREFS_KEY_IS_USER_LOGGED_IN);
    localStorage.remove('currentUser');
  }
}
