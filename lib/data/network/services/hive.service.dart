import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path/path.dart';

import '../../models/models.dart';

class HiveService {
  static const accountBoxName = 'accountsBox';
  static const usersBoxName = 'usersBox';
  static const chatsBoxName = 'chatsBox';

  late Future<bool> initDbFuture;

  HiveService() {
    initDbFuture = initDb();
  }

  // Chat management
  Future<void> addChats(List<Chat> chats) async {
    final box = Hive.box<Chat>(chatsBoxName);
    debugPrint("adding ${chats.length} to database");
    await box.putAll({for (var chat in chats) chat.id: chat});
  }

  ValueListenable<Box<Chat>> streamChat(String chatId) {
    final box = Hive.box<Chat>(chatsBoxName);

    return box.listenable(keys: [chatId]);
  }

  Future<void> sendMessage(Message message) async {
    try {
      final box = Hive.box<Chat>(chatsBoxName);
      var chat = box.get(message.chatId);
      chat?.messages.add(message);
      ChatController.to.sendMessage(message);
      chat?.save();
    } catch (e) {
      debugPrint("error sending message: ${e.toString()}");
    }
  }

  Future<void> updateMessage(Message message) async {
    try {
      message.save();
    } catch (e) {
      debugPrint("error with database: ${e.toString()}");
    }
  }

  Stream<List<Chat>> streamChats(String userId) async* {
    final box = Hive.box<Chat>(chatsBoxName);
    var chats = box.values.where((chat) => chat.users.any((user) => user.id == userId));
    yield* Stream.fromIterable(Iterable.generate(chats.length, (index) => chats.toList()));
  }

  Future<void> updateChat(Chat chat) async {
    final box = Hive.box<Chat>(chatsBoxName);
    var foundChat = box.get(chat.id);
    foundChat = chat;
    await foundChat.save();
    debugPrint("Saved to chat");
  }

  Future<void> deleteChat(String id) async {
    final box = Hive.box<Chat>(chatsBoxName);
    await box.delete(id);
  }

  // Account management
  Future<void> addAccount(Account account) async {
    final box = Hive.box<Account>(accountBoxName);
    debugPrint("Adding ${account.user.username} to accounts");
    await box.put(account.id, account);
  }

  Future<Account> getCurrentAccount() async {
    final box = Hive.box<Account>(accountBoxName);
    return box.values.firstWhere((account) => account.isActive = true);
  }

  Future<List<Account>> getAccounts() async {
    final box = Hive.box<Account>(accountBoxName);
    return box.values.toList();
  }

  // Future<void> optimizeDb() async {
  //   final service = await db;
  //   service.writeTxnSync(() => {
  //         service.chats.filter().usersIsEmpty().deleteAllSync(),
  //         // service.accounts.clearSync(),
  //       });
  // }

  Future<bool> isUserLoggedIn() async {
    await Hive.openBox<Account>(accountBoxName);
    final box = Hive.box<Account>(accountBoxName);
    return box.values.any((account) => account.isActive = true);
  }

  Future<void> logout(Account account) async {
    account.isActive = false;
    account.save();
    debugPrint("account logged out");
  }

  Future<bool> initDb() async {
    final appDocsDir = await path.getApplicationDocumentsDirectory();
    final hiveFolder = join(appDocsDir.path, 'hive');
    Hive.init(hiveFolder);
    try {
      Hive.registerAdapter(AccountAdapter());
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(ChatAdapter());
    } catch (e) {
      debugPrint(e.toString());
    }
    // await Hive.openBox<Account>(accountBoxName);
    await Hive.openBox<Chat>(chatsBoxName);
    debugPrint("Hive initialization done");
    return true;
  }
}
