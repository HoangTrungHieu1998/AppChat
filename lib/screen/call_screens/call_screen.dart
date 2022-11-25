import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/main.dart';
import 'package:skype_clone/screen/call_screens/user_call_container.dart';
import 'package:videosdk/videosdk.dart';

import '../../logic/user_provider.dart';
import '../../models/call.dart';
import '../../resources/call_methods.dart';
import '../../utils/setting.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  const CallScreen({
    super.key,
    required this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Map<String, Stream?> participantVideoStreams = {};
  final CallMethods callMethods = CallMethods();
  late Room room;

  UserProvider? userProvider;
  late StreamSubscription callStreamSubscription;
  // Camera Controller
  CameraController? cameraController;

  bool micEnabled = true;
  bool camEnabled = true;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initializeCall();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setParticipantStreamEvents(Participant participant) {
    participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => participantVideoStreams[participant.id] = stream);
      }
    });

    participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => participantVideoStreams.remove(participant.id));
      }
    });
  }

  void setMeetingEventListener(Room _room) {
    setParticipantStreamEvents(_room.localParticipant);
    _room.on(
      Events.participantJoined,
      (Participant participant) => setParticipantStreamEvents(participant),
    );
    _room.on(Events.participantLeft, (String participantId) {
      if (participantVideoStreams.containsKey(participantId)) {
        setState(() => participantVideoStreams.remove(participantId));
      }
    });
    _room.on(Events.roomLeft, () {
      // END CALL
      participantVideoStreams.clear();
    });
  }

  void initializeCall() {
    room = VideoSDK.createRoom(
      roomId: widget.call.channelId!,
      token: token,
      displayName: widget.call.callerName??"Guest",
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      maxResolution: 'hd',
      defaultCameraIndex: 1,
      notification: const NotificationInfo(
        title: "Video SDK",
        message: "Video SDK is sharing screen in the meeting",
        icon: "notification_share", // drawable icon name
      ),
    );

    setMeetingEventListener(room);

    // Join meeting
    room.join();
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods.callStream(uid: userProvider!.getUser!.uid).listen((DocumentSnapshot ds) {
        print("Call: ${ds.data()}");
      });
    });
  }

  void _onToggleMute() {
    setState(() {
      micEnabled ? room.muteMic() : room.unmuteMic();
      micEnabled = !micEnabled;
    });
  }

  void _onSwitchCamera() {
    setState(() {
      camEnabled ? room.disableCam() : room.enableCam();
      camEnabled = !camEnabled;
    });
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: micEnabled ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              micEnabled ? Icons.mic : Icons.mic_off,
              color: micEnabled ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(
              call: widget.call,
            ).then((value){
              room.end();
              Navigator.of(context).pop();
            }),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: UserCallContainer(meeting: room),),
              //_viewRows(),
              // _panel(),
              _toolbar(),
            ],
          ),
    ));
  }
}
