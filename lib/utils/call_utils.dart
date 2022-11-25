import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';

import '../models/call.dart';
import '../models/log.dart';
import '../resources/call_methods.dart';
import '../screen/call_screens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel? from, UserModel? to, context,required String token}) async {
    final channelID = await callMethods.createMeeting(token);

    Call call = Call(
      callerId: from!.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to!.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: channelID.toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: Constant.CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {

      // Enter Log
      LogRepository().addLogs(log);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}