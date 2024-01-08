import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:get/get.dart';
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

  Future<Account> getCurrentAccount() async {
    final service = await db;
    return (await service.accounts.filter().isActiveEqualTo(true).findFirst())!;
  }

  Future<List<Account>> getAccounts() async {
    final service = await db;
    return service.accounts.buildQuery<Account>().findAll();
  }

  Future<void> addChats(List<Chat> chats) async {
    final service = await db;
    debugPrint("adding ${chats.length} to database");
    service.writeTxnSync(() {
      service.chats.putAllSync(chats);
    });
  }

  // Future<void> addChatUsers(List<User> users) async {
  //   final service = await db;
  //   service.writeTxnSync(() => service.chats(users));
  // }

  Stream<Chat?> streamChat(String chatId) async* {
    final service = await db;
    yield* service.chats.watchObject(fastHash(chatId), fireImmediately: true);
  }

  Stream<List<Chat>> streamChats() async* {
    final service = await db;
    yield* service.chats.where().watch(fireImmediately: true);
  }

  Future<void> updateChat(Chat chat) async {
    final service = await db;
    service.writeTxnSync(() => service.chats.putSync(chat));
  }

  Future<void> deleteChat(String id) async {
    final service = await db;
    service.writeTxnSync(() => service.chats.deleteSync(fastHash(id)));
  }

  Future<void> addAccount(Account account) async {
    debugPrint("Adding ${account.user.username} to accounts");
    final service = await db;
    service.writeTxnSync(() => service.accounts.putSync(account));
  }

  Future<void> optimizeDb() async {
    final service = await db;
    service.writeTxnSync(() => {
          service.chats.filter().usersIsEmpty().deleteAllSync(),
          // service.accounts.clearSync(),
        });
  }

  Future<bool> isUserLoggedIn() async {
    final service = await db;
    final currentId = await service.accounts.filter().isActiveEqualTo(true).count();
    return currentId.isGreaterThan(0);
  }

  Future<void> logout(String id) async {
    final service = await db;
    service.writeTxnSync(() {
      final account = service.accounts.filter().idEqualTo(id).findFirstSync()?..isActive = false;
      service.accounts.putSync(account!);
    });
  }

  Future<Isar> initDb() async {
    final appDocsDir = await path.getApplicationDocumentsDirectory();
    return await Isar.open([AccountSchema, ChatSchema], directory: appDocsDir.path);
  }
}
