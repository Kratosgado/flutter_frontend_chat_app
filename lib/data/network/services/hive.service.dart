import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/network/services/chat.controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path/path.dart';

import '../../models/models.dart';

class HiveService {
  static const accountBoxName = 'accountsBox';
  static const usersBoxName = 'usersBox';
  static const chatsBoxName = 'chatsBox';
  static const messageBoxName = 'messageBox';

  late Future<bool> initDbFuture;

  HiveService() {
    initDbFuture = initDb();
  }

  // Chat management
  Future<void> addChats(List<Chat> chats) async {
    final box = Hive.box<Chat>(chatsBoxName);
    // chats.map((e) => e.messages.box.(e) => )
    debugPrint("adding ${chats.length} to database");
    await box.putAll({for (var chat in chats) chat.id: chat});
  }

  Future<void> sendMessage(Message message) async {
    try {
      final box = Hive.box<Chat>(chatsBoxName);
      var chat = box.get(message.chatId);

      chat?.messages.add(message);
      ChatController().sendMessage(message);
      await chat?.save();
      debugPrint("sending message: ${message.text}");
    } catch (e) {
      debugPrint("error sending message: ${e.toString()}");
    }
  }

  Future<void> deleteMessage({required String chatId, required String messageId}) async {
    try {
      final box = Hive.box<Chat>(chatsBoxName);
      var chat = box.get(chatId);
      chat?.messages.removeWhere((element) => element.id == messageId);
      await chat?.save();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateMessage(Message message) async {
    try {
      final box = Hive.box<Chat>(chatsBoxName);
      var chat = box.get(message.chatId);
      chat?.messages.map((mess) => {
            debugPrint("lsdfjl"),
            if (mess.id == message.id)
              {
                debugPrint("message status: ${mess.status}"),
              }
          });
      debugPrint("new message id: ${message.status}");
      await chat?.save();
    } catch (e) {
      debugPrint("error with database: ${e.toString()}");
    }
  }

  Future<void> updateChat(Chat chat) async {
    try {
      final box = Hive.box<Chat>(chatsBoxName);
      await box.put(chat.id, chat);
      debugPrint("Saved to chat");
    } catch (e) {
      debugPrint(e.toString());
    }
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
    return box.values.firstWhere((account) => account.isActive == true);
  }

  List<Account> getAccounts() {
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
    final box = Hive.box<Account>(accountBoxName);
    return box.values.any((account) => account.isActive == true);
  }

  Future<void> logout(Account account) async {
    account.isActive = false;
    await account.save();
    debugPrint("account logged out: ${account.isActive}");
  }

  Future<bool> initDb() async {
    try {
      final appDocsDir = await path.getApplicationDocumentsDirectory();
      final hiveFolder = join(appDocsDir.path, 'hives');
      Hive.init(hiveFolder);
      Hive.registerAdapter(AccountAdapter());
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(ChatAdapter());
      Hive.registerAdapter(MessageStatusAdapter());
    } catch (e) {
      debugPrint(e.toString());
    }

    await Hive.openBox<Account>(accountBoxName);
    await Hive.openBox<Message>(messageBoxName);
    await Hive.openBox<Chat>(chatsBoxName);
    debugPrint("Hive initialization done");
    return true;
  }
}
