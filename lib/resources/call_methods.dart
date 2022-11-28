import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/history.dart';
import 'package:skype_clone/models/log.dart';

import '../models/call.dart';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/setting.dart';

class CallMethods{
  final CollectionReference callCollection =
  FirebaseFirestore.instance.collection(Constant.callCollection);
  final CollectionReference historyCollection =
  FirebaseFirestore.instance.collection(Constant.historyCallCollection);

  Stream<DocumentSnapshot> callStream({String? uid}) =>
      callCollection.doc(uid).snapshots();

  Stream<DocumentSnapshot> fetchHistoryCall({required String userId}) => historyCollection
      .doc(userId)
      .snapshots();

  Future<bool> makeCall({Call? call,Log? log}) async {
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

  Future<void> addHistoryCallToDb (Log log) async{
    List<Log> list = [];
    History history;
    await historyCollection
        .doc(log.callerId)
        .get()
        .then((DocumentSnapshot snapshot){
          if(snapshot.exists){
            if(snapshot.data()!=null){
              final data = snapshot.data() as Map<String, dynamic>;
              list.addAll(History.fromJson(data).history!);
              list.add(log);
              history = History(
                history: list
              );
              FirebaseFirestore.instance
                  .collection(Constant.historyCallCollection)
                  .doc(log.callerId)
                  .set(history.toJson());
            }else{
              list.add(log);
              history = History(
                  history: list
              );
              FirebaseFirestore.instance
                  .collection(Constant.historyCallCollection)
                  .doc(log.callerId)
                  .set(history.toJson());
            }
          }else{
            list.add(log);
            history = History(
                history: list
            );
            FirebaseFirestore.instance
                .collection(Constant.historyCallCollection)
                .doc(log.callerId)
                .set(history.toJson());
          }
        });
  }
}