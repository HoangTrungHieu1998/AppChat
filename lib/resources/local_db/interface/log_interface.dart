import '../../../models/log.dart';

abstract class LogInterFace{
  init();

  addLogs(Log log);

  openDb(dbName);

  // returns a list of logs
  Future<List<Log>?> getLogs();

  deleteLogs(int logId);

  close();
}