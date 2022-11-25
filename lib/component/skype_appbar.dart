import 'package:flutter/material.dart';
import 'package:skype_clone/component/custom_appbar.dart';

class SkypeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final List<Widget> actions;

  const SkypeAppBar({Key? key, this.title, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
        title: (title is String)
            ? Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : title,
        actions: actions,
        leading: IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        centerTitle: true
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
