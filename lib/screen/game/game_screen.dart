import 'package:flutter/material.dart';
import 'package:skype_clone/component/skype_appbar.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/screen/game/tic_tac_toe.dart';

import '../../component/app_theme.dart';
import '../../component/cache_image.dart';
import '../../component/custom_title.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SkypeAppBar(
        title: "Games",
        actions: [

        ],
      ),
      backgroundColor: AppThemes.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            children: [
              CustomTitle(
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TicTacToe())),
                leading: const CachedImage(
                  imageUrl: Constant.tictactoe,
                  isRound: true,
                  radius: 45,
                ),
                mini: false,
                title: const Text(
                  "Tic Tac Toe",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppThemes.colorWhite
                  ),
                ),
                subtitle: const Text(
                  "Tic tac toe",
                  style: TextStyle(
                      fontSize: 13,
                      color: AppThemes.colorWhite
                  ),
                ),
              ),
              CustomTitle(
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TicTacToe())),
                leading: const CachedImage(
                  imageUrl: Constant.cacheImage,
                  isRound: true,
                  radius: 45,
                ),
                mini: false,
                title: const Text(
                  "Lucky Number",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppThemes.colorWhite
                  ),
                ),
                subtitle: const Text(
                  "get lucky number for today",
                  style: TextStyle(
                      fontSize: 13,
                      color: AppThemes.colorWhite
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
