import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
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

  // Chat management
  Future<void> addChats(List<Chat> chats) async {
    final service = await db;
    debugPrint("adding ${chats.length} to database");
    service.writeTxnSync(() {
      service.chats.putAllSync(chats);
    });
  }

  Stream<Chat?> streamChat(String chatId) async* {
    final service = await db;
    yield* service.chats.watchObject(fastHash(chatId), fireImmediately: true);
  }

  Future<void> sendMessage(Message message) async {
    try {
      final service = await db;
      ChatController.to.sendMessage(message);
      service.writeTxnSync(() async {
        // final chat = service.chats.getSync(fastHash(message.chatId!))!;
        final chat = service.chats.where().chatIdEqualTo(fastHash(message.chatId!)).findFirstSync();
        chat!.messages = chat.messages.toList();
        chat.messages.add(message);
        service.chats.putSync(chat);
      });
    } catch (e) {
      debugPrint("error sending message: ${e.toString()}");
    }
  }

  Future<void> updateMessage(Message message) async {
    try {
      final service = await db;
      service.writeTxnSync(() {
        final chat = service.chats.getSync(fastHash(message.chatId!));
        chat!.messages = chat.messages.toList();
        chat.messages
            .insert(chat.messages.indexWhere((element) => element.id == message.id), message);
        service.chats.putSync(chat);
      });
    } catch (e) {
      debugPrint("error with database: ${e.toString()}");
    }
  }

  Stream<List<Chat>> streamChats(String userId) async* {
    final service = await db;
    yield* service.chats
        .filter()
        .usersElement((user) => user.idEqualTo(userId))
        .watch(fireImmediately: true);
  }

  Future<void> updateChat(Chat chat) async {
    final service = await db;
    service.writeTxnSync(() => service.chats.putSync(chat));
  }

  Future<void> deleteChat(String id) async {
    final service = await db;
    service.writeTxnSync(() => service.chats.deleteSync(fastHash(id)));
  }

  // Account management
  Future<void> addAccount(Account account) async {
    debugPrint("Adding ${account.user.username} to accounts");
    final service = await db;
    service.writeTxnSync(() => service.accounts.putSync(account));
  }

  Future<Account> getCurrentAccount() async {
    final service = await db;
    return (await service.accounts.filter().isActiveEqualTo(true).findFirst())!;
  }

  Future<List<Account>> getAccounts() async {
    final service = await db;
    return service.accounts.buildQuery<Account>().findAll();
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
