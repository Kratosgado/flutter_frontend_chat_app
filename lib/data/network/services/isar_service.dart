import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;

class IsarService {
  late Future<Isar> db;

  // static get service =>  db;

  IsarService() {
    db = initDb();
  }

  Future<List<Account>> getAccounts() async {
    final service = await db;
    return service.accounts.buildQuery<Account>().findAll();
  }

  Future<void> addAccount(Account account) async {
    debugPrint("Adding ${account.username} to accounts");
    final service = await db;
    await service.accounts.put(account);
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
    return await Isar.open([AccountSchema], directory: appDocsDir.path);
  }
}
