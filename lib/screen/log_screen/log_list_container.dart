import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/component/app_utils.dart';
import 'package:skype_clone/component/custom_title.dart';
import 'package:skype_clone/const.dart';

import '../../component/cache_image.dart';
import '../../models/log.dart';
import '../../resources/local_db/repository/log_repository.dart';
import '../chat_screen/quite_box.dart';

class LogListContainer extends StatefulWidget {
  const LogListContainer({super.key});

  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
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
    return FutureBuilder<dynamic>(
      future: LogRepository().getLogs(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i];
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
                            await LogRepository().deleteLogs(i);
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