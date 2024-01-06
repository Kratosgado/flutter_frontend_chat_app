import 'package:isar/isar.dart';

part 'account.g.dart';

@Collection()
class Account {
  Id? id;
  String? username;
  String? email;
  String? password;

  bool? isActive;
}
