import 'package:flutter/material.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';

import '../../../component/cache_image.dart';
import '../../../models/call.dart';
import '../../../resources/call_methods.dart';
import '../../../utils/permission.dart';
import '../call_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  const PickupScreen({super.key,
    required this.call,
  });

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  final LogRepository repository = LogRepository();

  bool isCallMissed = true;

  addToLocalStorage({required String callStatus}){
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      callStatus: callStatus,
      timestamp: DateTime.now().toString(),
    );
    repository.addLogs(log);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(isCallMissed){
      addToLocalStorage(callStatus: Constant.CALL_STATUS_MISSED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 50),
            CachedImage(
              imageUrl: widget.call.callerPic ?? Constant.cacheImage,
              isRound: true,
              radius: 180,
            ),
            const SizedBox(height: 15),
            Text(
              widget.call.callerName ?? "Hieu",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: Constant.CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                const SizedBox(width: 25),
                IconButton(
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: Constant.CALL_STATUS_RECEIVED);
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(call: widget.call),
                      ),
                    )
                        : {};
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}