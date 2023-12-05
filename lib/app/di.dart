import 'package:flutter_frontend_chat_app/app/app_refs.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data/network/network_info.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final localStorage =  GetStorage();

  // shared prefs instance
  instance.registerLazySingleton<GetStorage>(() => localStorage);

  // app prefs instance
  instance.registerLazySingleton(() => AppPreferences(instance()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));
}
