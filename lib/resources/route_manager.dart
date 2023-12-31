import 'package:flutter_frontend_chat_app/views/auth/login.dart';
import 'package:flutter_frontend_chat_app/views/chat/chat.view.dart';
import 'package:flutter_frontend_chat_app/views/chat/chatlist.view.dart';
import 'package:flutter_frontend_chat_app/views/splash/splash.dart';
import 'package:flutter_frontend_chat_app/views/user/user.profile.dart';
import 'package:flutter_frontend_chat_app/views/user/user_list.dart';
import 'package:get/get.dart';

import '../views/auth/signup.dart';

class Routes {
  static const String splashRoute = "/";
  static const String signupRoute = "/signup";
  static const String loginRoute = "/login";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String chatList = "/chatlist";
  static const String chat = "/chat";
  static const String userList = "/users";
  static const String userProfile = "/userProfile";
}

List<GetPage> getRoutes() => [
      GetPage(name: Routes.splashRoute, page: () => const SplashView()),
      GetPage(name: Routes.loginRoute, page: () => const LoginView()),
      GetPage(name: Routes.signupRoute, page: () => const SignUpView()),
      GetPage(name: Routes.forgotPasswordRoute, page: () => const SplashView()),
      GetPage(name: Routes.chatList, page: () => const ChatListView()),
      GetPage(name: Routes.userList, page: () => const UserListView()),
      GetPage(name: Routes.chat, page: () => ChatView()),
      GetPage(name: Routes.userProfile, page: () => const UserProfileView())
    ];
