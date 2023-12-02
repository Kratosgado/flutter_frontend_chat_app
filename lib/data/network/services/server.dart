import 'package:get/get.dart';

import '../../../app/app_refs.dart';
import '../../../app/di.dart';

const BASEURL = 'http://localhost:4000';

class ServerService extends GetxService {
  final _connect = GetConnect();
  final _appPreference = instance<AppPreferences>();

  Future<void> signUp(String email, String username, String password) async {
    await _connect
        .post('$BASEURL/user/signup', {"username": username, "email": email, "password": password})
        .then((value) async => await signIn(email, password))
        .catchError((err) {
          Get.snackbar("Sign Up Error Failed", err);
        });
  }

  Future<void> signIn(String email, String password) async {
    try {
      Response response =
          await _connect.post('$BASEURL/user/signin', {"email": email, "password": password});
      _appPreference.setUserTokenn(response.body);
    } catch (e) {
      Get.snackbar('Sign In Failed', e.toString());
    }
  }
}
