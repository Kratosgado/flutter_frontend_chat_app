import 'package:isar/isar.dart';

part 'account.g.dart';

@Collection()
class Account {
  Id id = Isar.autoIncrement;
  String? username;
  String? email;
  String? profilePic;
  String? password;

  bool? isActive;
}
