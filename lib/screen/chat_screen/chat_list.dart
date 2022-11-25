import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/component/custom_title.dart';
import 'package:skype_clone/logic/user_provider.dart';
import 'package:skype_clone/resources/chat_methods.dart';
import 'package:skype_clone/screen/chat_screen/quite_box.dart';

import '../../models/contact.dart';
import 'contact_view.dart';

class ChatList extends StatelessWidget {
  final ChatMethods chatMethods = ChatMethods();

  ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: chatMethods.fetchContacts(
          userId: userProvider.getUser!.uid!,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data!.docs;

            if (docList.isEmpty) {
              return QuietBox();
            }
            //return const Center(child: Text("No Contact Info"));
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                Contact contact = Contact.fromJson(docList[index].data() as Map<String,dynamic>);

                return ContactView(contact);
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
