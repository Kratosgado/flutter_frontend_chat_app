import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../../models/models.dart';

class IsarService {
  late Future<Isar> db;

  // static get service =>  db;

  IsarService() {
    db = initDb();
    optimizeDb();
  }

  Future<List<Account>> getAccounts() async {
    final service = await db;
    return service.accounts.buildQuery<Account>().findAll();
  }

  Future<void> addChats(List<Chat> chats) async {
    final service = await db;
    debugPrint("adding ${chats.length} to database");
    service.writeTxnSync(() {
      for (var chat in chats) {
        service.users.putAllSync(chat.users.toList());
        service.messages.putAllSync(chat.messages.toList());
      }
      service.chats.putAllSync(chats);
    });
  }

  Future<void> addChatUsers(List<User> users) async {
    final service = await db;
    service.writeTxnSync(() => service.users.putAllSync(users));
  }

  Stream<List<Chat>> streamChats() async* {
    final service = await db;
    yield* service.chats.where().watch(fireImmediately: true);
  }

  Future<void> addAccount(Account account) async {
    debugPrint("Adding ${account.username} to accounts");
    final service = await db;
    service.writeTxnSync(() => service.accounts.putSync(account));
  }

  Future<void> optimizeDb() async {
    final service = await db;
    service.writeTxnSync(() => service.chats.filter().usersIsEmpty().deleteAllSync());
  }

  Future<void> logout(String email) async {
    final service = await db;
    service.writeTxnSync(() {
      final account = service.accounts.filter().emailEqualTo(email).findFirstSync()
        ?..isActive = false;
      service.accounts.putSync(account!);
    });
  }

  Future<Isar> initDb() async {
    final appDocsDir = await path.getApplicationDocumentsDirectory();
    return await Isar.open([AccountSchema, MessageSchema, UserSchema, ChatSchema],
        directory: appDocsDir.path);
  }
}
