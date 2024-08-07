// ignore_for_file: constant_identifier_names

// const baseUrl = String.fromEnvironment("HOST_URL", defaultValue: "http://localhost:4000");
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env["HOST_URL"];

class AppStrings {
  static const String noRouteFound = "no_route_found";

  static const String skip = "skip";
  static const String username = "username_hint";
  static const String mobileNumber = "mobile_number_hint";
  static const String usernameError = "invalid_user_name";
  static const String passwordError = "invalid_password";
  static const String password = "password_hint";
  static const String signin = "Sign In";
  static const String forgetPassword = "forgot_password_text";
  static const String registerText = "register_text";
  static const String loading = "loading";
  static const String retryAgain = "retry_again";
  static const String ok = "ok";
  static const String emailHint = 'email_hint';
  static const String invalidEmail = "invalid_email";
  static const String resetPassword = "reset_password";
  static const String success = "success";
  static const String profilePicture = "upload_profile_picture";
  static const String photoGalley = "photo_gallery";
  static const String photoCamera = "camera";
  static const String signup = "Sign Up";
  static const String haveAccount = "already_have_account";
  static const String home = "home";
  static const String notifications = "notification";
  static const String search = "search";
  static const String settings = "settings";
  static const String services = "services";
  static const String stores = "stores";
  static const String details = "details";
  static const String about = "about";
  static const String storeDetails = "store_details";
  static const String changeLanguage = "change_language";
  static const String contactUs = "contact_us";
  static const String inviteYourFriends = "invite_your_friends";
  static const String logout = "logout";

  // error handler
  static const String badRequestError = "bad_request_error";
  static const String noContent = "no_content";
  static const String forbiddenError = "forbidden_error";
  static const String unauthorizedError = "unauthorized_error";
  static const String notFoundError = "not_found_error";
  static const String conflictError = "conflict_error";
  static const String internalServerError = "internal_server_error";
  static const String unknownError = "unknown_error";
  static const String timeoutError = "timeout_error";
  static const String defaultError = "default_error";
  static const String cacheError = "cache_error";
  static const String noInternetError = "no_internet_error";
}

class ServerStrings {
  // Auth
  static  String signup = '$baseUrl/auth/signup';
  static  String login = '$baseUrl/auth/login';

  // User
  static  String getUsers = '$baseUrl/user/findall';
  static  String getMe = '$baseUrl/user/me';
  static  String getUser = '$baseUrl/user/find';
  static  String updateUser = '$baseUrl/user/update';
  static  String getProfilePic = '$baseUrl/user/getProfilePic';
  static  String deleteUser = '$baseUrl/user/delete';

  // Chat
  static const String findAllChats = 'findAllChats';
  static const String returningChats = 'returningChats';

  static const String findOneChat = 'findOneChat';
  static const String returningChat = 'returningChat';

  static const String createChat = 'createChat';
  static const String chatCreated = 'chatCreated';

  static const String deleteChat = 'deleteChat';
  static const String chatDeleted = 'chatDeleted';

  static const String newMessage = 'newMessage';
  static const String messageDelivered = 'messageDelivered';

  static const String sendMessage = 'sendMessage';
  static const String deleteMessage = 'deleteMessage';
  static const String messageDeleted = 'messageDeleted';

  static const String deleteSocketMessage = 'deleteSocketMessage';
}
