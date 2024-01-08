import 'package:flutter_frontend_chat_app/data/models/models.dart';
import 'package:isar/isar.dart';

part 'account.g.dart';

@Collection()
class Account {
  late String id;
  Id get accountId => fastHash(id);
  String? username;
  String? email;
  String? profilePic;
  String? password;

  bool? isActive = false;
}
