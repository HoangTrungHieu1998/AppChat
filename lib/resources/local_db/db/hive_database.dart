import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/interface/log_interface.dart';

class HiveDatabase implements LogInterFace{
  String hiveBox = "Call_Logs";

  @override
  addLogs(Log log) async{
    try{
      var box = await Hive.openBox(hiveBox);

      var logMap = log.toJson(log);

      // box.put("custom_key", logMap);
      int idOfInput = await box.add(logMap);

      close();
      print("Success:$idOfInput");

      return idOfInput;
    }catch(e){
      print("Add Failed");
    }

  }

  updateLogs(int i, Log newLog) async {
    var box = await Hive.openBox(hiveBox);

    var newLogMap = newLog.toJson(newLog);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  close() {
    Hive.close();
  }

  @override
  deleteLogs(int logId) async{
    var box = await Hive.openBox(hiveBox);
    await box.deleteAt(logId);
  }

  @override
  Future<List<Log>?> getLogs() async{
    var box = await Hive.openBox(hiveBox);
    List<Log> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);
      print("Type: ${logMap.runtimeType}");

      logList.add(Log.fromJson(jsonDecode(logMap)));
    }
    return logList;
  }

  @override
  init() async{
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  openDb(dbName) =>(hiveBox = dbName);

}