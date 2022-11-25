import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screen/call_screens/pickup/pickup_screen.dart';

import '../../../logic/user_provider.dart';
import '../../../models/call.dart';
import '../../../resources/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                Call call = Call.fromJson(snapshot.data!.data() as Map<String, dynamic>);

                if (!call.hasDialled!) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
