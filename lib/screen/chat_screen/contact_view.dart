import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/screen/chat_screen/chat_detail.dart';

import '../../component/cache_image.dart';
import '../../component/custom_title.dart';
import '../../logic/user_provider.dart';
import '../../models/contact.dart';
import '../../resources/auth_methods.dart';
import '../../resources/chat_methods.dart';
import 'last_message_container.dart';
import 'outline_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data !=null) {
          UserModel user = snapshot.data!;

          return ViewLayout(
            contact: user,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserModel contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTitle(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetail(
              receiver: contact,
            ),
          )),
      title: Text(
        contact.name ?? "..",
        style:
        const TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser!.uid!,
          receiverId: contact.uid!,
        ),
      ),
      leading: Container(
        constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              imageUrl: contact.profilePhoto??Constant.cacheImage,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid!,
            )
          ],
        ),
      ),
    );
  }
}