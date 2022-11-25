import 'package:skype_clone/resources/local_db/db/hive_database.dart';
import 'package:skype_clone/resources/local_db/db/sql_database.dart';

import '../../../models/log.dart';

class LogRepository {
  late SqlDatabase database = SqlDatabase();
  static bool? isHive;

  init({required bool isHive, required String dbName}) {
    database.openDb(dbName);
    database.init();
  }

  addLogs(Log log) => database.addLogs(log);

  deleteLogs(int logId) => database.deleteLogs(logId);

  getLogs() => database.getLogs();

  close() => database.close();
}