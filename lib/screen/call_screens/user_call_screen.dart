import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:videosdk/videosdk.dart';

class UserCallScreen extends StatelessWidget {
  final Stream? stream;
  final bool isMicOn;
  final double avatarTextSize;

  const UserCallScreen({
    Key? key,
    required this.stream,
    required this.isMicOn,
    this.avatarTextSize = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        stream != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RTCVideoView(
                  stream?.renderer as RTCVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              )
            : Center(
                child: Container(
                  padding: EdgeInsets.all(avatarTextSize / 2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppThemes.black700,
                  ),
                  child: const Icon(
                    Icons.person
                  ),
                ),
              ),
        if (!isMicOn)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppThemes.black700,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.mic_off,
                  size: avatarTextSize / 2,
                  color: AppThemes.colorWhite,
                )),
          ),
      ],
    );
  }
}
