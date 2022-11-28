import 'package:skype_clone/const.dart';

class Log{
  int? logId;
  String? callerName;
  String? callerId;
  String? callerPic;
  String? receiverName;
  String? receiverId;
  String? receiverPic;
  String? callStatus;
  String? timestamp;

  Log({
    this.logId,
    this.callerName,
    this.callerId,
    this.callerPic,
    this.receiverName,
    this.receiverId,
    this.receiverPic,
    this.callStatus,
    this.timestamp
  });

  factory Log.fromJson(Map<String, dynamic> json){
    return Log(
      logId: json["log_id"],
      callerName: json["caller_name"],
      callerId: json["caller_id"],
      callerPic: json["caller_pic"]??Constant.cacheImage,
      receiverName: json["receiver_name"],
      receiverId: json["receiver_id"],
      receiverPic: json["receiver_pic"]??Constant.cacheImage,
      callStatus: json["call_status"],
      timestamp: json["timestamp"],
    );
  }

  Map<String,dynamic> toJson(Log call) {
    final data = <String, dynamic>{};
    data['log_id'] = logId;
    data['caller_name'] = callerName;
    data['caller_id'] = callerId;
    data['caller_pic'] = callerPic;
    data['receiver_name'] = receiverName;
    data['receiver_id'] = receiverId;
    data['receiver_pic'] = receiverPic;
    data['call_status'] = callStatus;
    data['timestamp'] = timestamp;
    return data;
  }

  Map toMap() {
    final data = <String, dynamic>{};
    data['log_id'] = logId;
    data['caller_name'] = callerName;
    data['caller_id'] = callerId;
    data['caller_pic'] = callerPic;
    data['receiver_name'] = receiverName;
    data['receiver_id'] = receiverId;
    data['receiver_pic'] = receiverPic;
    data['call_status'] = callStatus;
    data['timestamp'] = timestamp;
    return data;
  }
}