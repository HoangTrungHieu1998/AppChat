class Call {
  String? callerId;
  String? callerName;
  String? callerPic;
  String? receiverId;
  String? receiverName;
  String? receiverPic;
  String? channelId;
  bool? hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled
  });

  factory Call.fromJson(Map<String, dynamic> json){
    return Call(
      callerId: json["caller_id"],
      callerName: json["caller_name"],
      callerPic: json["caller_pic"],
      receiverId: json["receiver_id"],
      receiverName: json["receiver_name"],
      receiverPic: json["receiver_pic"],
      channelId: json["channel_id"],
      hasDialled: json["has_dialled"],
    );
  }

  Map<String,dynamic> toJson(Call call) {
    final data = <String, dynamic>{};
    data['caller_id'] = callerId;
    data['caller_name'] = callerName;
    data['caller_pic'] = callerPic;
    data['receiver_id'] = receiverId;
    data['receiver_name'] = receiverName;
    data['receiver_pic'] = receiverPic;
    data['channel_id'] = channelId;
    data['has_dialled'] = hasDialled;
    return data;
  }
}
