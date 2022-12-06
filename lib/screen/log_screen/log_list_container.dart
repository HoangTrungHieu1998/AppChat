import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/component/app_utils.dart';
import 'package:skype_clone/component/custom_title.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/history.dart';
import 'package:skype_clone/resources/call_methods.dart';

import '../../component/cache_image.dart';
import '../../logic/user_provider.dart';
import '../../models/log.dart';
import '../../resources/local_db/repository/log_repository.dart';
import '../chat_screen/quite_box.dart';

class LogListContainer extends StatefulWidget {
  const LogListContainer({super.key});

  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  final CallMethods callMethods = CallMethods();

  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case Constant.CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case Constant.CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: callMethods.fetchHistoryCall(
        userId: userProvider.getUser!.uid!
      ),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.data() !=null) {
          History history = History.fromJson(snapshot.data!.data() as Map<String,dynamic>);
          print("CHATDETAIL:${snapshot.data!.data()}");

          if (history.history!.isNotEmpty) {
            var seen = <String>{};
            history.history!.sort((a, b)=> DateTime.parse(b.timestamp!).compareTo(DateTime.parse(a.timestamp!)));
            List<Log> listLog = history.history!.where((log) => seen.add(log.receiverId!)).toList();
            return ListView.builder(
              itemCount: listLog.length,
              itemBuilder: (context, i) {
                Log _log = listLog[i];
                bool hasDialled = _log.callStatus == Constant.CALL_STATUS_DIALLED;

                return CustomTitle(
                  leading: CachedImage(
                    imageUrl: hasDialled ? _log.receiverPic! : _log.callerPic!,
                    isRound: true,
                    radius: 45,
                  ),
                  mini: false,
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete this Log?"),
                      content:
                      const Text("Are you sure you wish to delete this log?"),
                      actions: [
                        RawMaterialButton(
                          child: const Text("YES"),
                          onPressed: () async {
                            Navigator.maybePop(context);
                            await callMethods.deleteHistoryCall(userProvider.getUser!.uid!, _log);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                        RawMaterialButton(
                          child: const Text("NO"),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    hasDialled ? _log.receiverName! : _log.callerName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppThemes.colorWhite
                    ),
                  ),
                  icon: getIcon(_log.callStatus!),
                  subtitle: Text(
                    AppUtils.formatDateString(_log.timestamp!),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppThemes.colorWhite
                    ),
                  ),
                );
              },
            );
          }
          return const QuietBox(
            heading: "Error Log List ",
            subtitle: "Calling people all over the world with just one click",
          );
        }

        return const QuietBox(
          heading: "Log List Null",
          subtitle: "Calling people all over the world with just one click",
        );
      },
    );
  }
}