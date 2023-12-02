import 'package:flutter_frontend_chat_app/views/auth/login.dart';
import 'package:flutter_frontend_chat_app/views/splash/splash.dart';
import 'package:get/get.dart';

class Routes {
  static const String splashRoute = "/";
  static const String signupRoute = "/signup";
  static const String loginRoute = "/login";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String chatList = "/chatlist";
  static const String chat = "/chat";
}

List<GetPage> getRoutes() => [
  GetPage(name: Routes.splashRoute, page: () => const SplashView()),
  GetPage(name: Routes.loginRoute, page: () => const LoginView()),
  GetPage(name: Routes.signupRoute, page: () => const SplashView()),
  GetPage(name: Routes.forgotPasswordRoute, page: () => const SplashView()),
  GetPage(name: Routes.chat, page: () => const SplashView()),

];
