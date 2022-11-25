import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';

class NewChatButton extends StatelessWidget {
  const NewChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppThemes.fabGradient,
          borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.all(15),
      child: const Icon(
        CupertinoIcons.bubble_left_bubble_right,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}