import 'package:skype_clone/const.dart';

class Log{
  int? logId;
  String? callerName;
  String? callerPic;
  String? receiverName;
  String? receiverPic;
  String? callStatus;
  String? timestamp;

  Log({
    this.logId,
    this.callerName,
    this.callerPic,
    this.receiverName,
    this.receiverPic,
    this.callStatus,
    this.timestamp
  });

  factory Log.fromJson(Map<String, dynamic> json){
    return Log(
      logId: json["log_id"],
      callerName: json["caller_name"],
      callerPic: json["caller_pic"]??Constant.cacheImage,
      receiverName: json["receiver_name"],
      receiverPic: json["receiver_pic"]??Constant.cacheImage,
      callStatus: json["call_status"],
      timestamp: json["timestamp"],
    );
  }

  Map<String,dynamic> toJson(Log call) {
    final data = <String, dynamic>{};
    data['log_id'] = logId;
    data['caller_name'] = callerName;
    data['caller_pic'] = callerPic;
    data['receiver_name'] = receiverName;
    data['receiver_pic'] = receiverPic;
    data['call_status'] = callStatus;
    data['timestamp'] = timestamp;
    return data;
  }
}