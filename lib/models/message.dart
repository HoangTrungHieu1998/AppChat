import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? senderId;
  String? receiverId;
  String? type;
  String? message;
  Timestamp? timestamp;
  String? photoUrl;

  Message({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timestamp,
    this.photoUrl
  });

  Message.imageMessage({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timestamp,
    this.photoUrl
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      type: json["type"],
      message: json["message"],
      timestamp: json["timestamp"],
      photoUrl: json["photoUrl"],
    );
  }

  Map toMap() {
    final data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['type'] = type;
    data['message'] = message;
    data['timestamp'] = timestamp;
    data['photoUrl'] = photoUrl;
    return data;
  }

  Map toImageMap() {
    final data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['type'] = type;
    data['message'] = message;
    data['timestamp'] = timestamp;
    data['photoUrl'] = photoUrl;
    return data;
  }
}