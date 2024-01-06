import 'package:flutter_frontend_chat_app/data/models/isar_models/account.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;

class IsarService {
  late Future<Isar> db;

  // static get service =>  db;

  IsarService() {
    db = initDb();
  }

  Future<Isar> initDb() async {
    final appDocsDir = await path.getApplicationDocumentsDirectory();
    return await Isar.open([AccountSchema], directory: appDocsDir.path);
  }
}
