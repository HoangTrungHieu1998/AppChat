import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.actions,
    required this.leading,
    required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: AppThemes.blackColor,
        border: Border(
          bottom: BorderSide(
            color: AppThemes.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: AppThemes.blackColor,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}