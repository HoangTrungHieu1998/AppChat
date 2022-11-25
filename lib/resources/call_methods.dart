import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:skype_clone/const.dart';

import '../models/call.dart';

import 'package:http/http.dart' as http;

import '../utils/setting.dart';

class CallMethods{
  final CollectionReference callCollection =
  FirebaseFirestore.instance.collection(Constant.callCollection);

  Stream<DocumentSnapshot> callStream({String? uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({Call? call}) async {
    try {
      call!.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toJson(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toJson(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call? call}) async {
    try {
      await callCollection.doc(call!.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> createMeeting(String token) async {
    final http.Response httpResponse = await http.post(
      Uri.parse("https://api.videosdk.live/v2/rooms"),
      headers: {'Authorization': token},
    );

    return json.decode(httpResponse.body)['roomId'];
  }

  Future<String> getToken() async {
    final http.Response httpResponse = await http.get(
      Uri.parse("https://gist.githubusercontent.com/HoangTrungHieu1998/84be1f0010d6a9c3c5e4d98c35d686f0/raw/e33c2da4104e133a0e27af15d1b86c464689f948"),
    );

    return json.decode(httpResponse.body)['token'];
  }
}