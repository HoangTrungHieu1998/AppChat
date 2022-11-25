import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_utils.dart';
import 'package:skype_clone/models/user.dart';

import '../../enum/user_state.dart';
import '../../resources/auth_methods.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();
  UserModel userModel = UserModel();

  OnlineDotIndicator({super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int? state) {
      switch (AppUtils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data !=null && snapshot.data!.data() != null) {
            userModel = UserModel.fromJson(snapshot.data!.data() as Map<String,dynamic>);
          }

          return Container(
            height: 15,
            width: 15,
            margin: const EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(userModel.state),
            ),
          );
        },
      ),
    );
  }
}