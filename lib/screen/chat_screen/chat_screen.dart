import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/component/app_utils.dart';
import 'package:skype_clone/component/skype_appbar.dart';
import 'package:skype_clone/screen/call_screens/pickup/pickup_layout.dart';
import 'package:skype_clone/screen/chat_screen/search_screen.dart';

import '../../component/custom_appbar.dart';
import '../../resources/auth_methods.dart';
import 'chat_list.dart';
import 'circle_avatar.dart';
import 'new_chat_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final AuthMethods authMethods = AuthMethods();

class _ChatScreenState extends State<ChatScreen> {
  String currentUserId = "";
  String initials = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = authMethods.getCurrentUser();
    currentUserId = user!.uid;
    initials = AppUtils.getInitials(user.displayName, user.email!);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
          backgroundColor: AppThemes.blackColor,
          appBar: SkypeAppBar(
            title: const Avatar(),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButton: const NewChatButton(),
          body: ChatList(),
    ));
  }
}
