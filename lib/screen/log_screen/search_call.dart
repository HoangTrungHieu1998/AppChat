import 'package:flutter/material.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/resources/call_methods.dart';

import '../../component/app_theme.dart';
import '../../component/cache_image.dart';
import '../../component/custom_title.dart';
import '../../models/log.dart';
import '../../models/user.dart';
import '../../resources/auth_methods.dart';
import '../../utils/call_utils.dart';

class SearchCall extends StatefulWidget {
  const SearchCall({Key? key}) : super(key: key);

  @override
  State<SearchCall> createState() => _SearchCallState();
}

class _SearchCallState extends State<SearchCall> {
  final AuthMethods authMethods = AuthMethods();
  final CallMethods callMethods = CallMethods();

  late List<UserModel> userList = [];
  String? token;
  UserModel? sender;
  Log? log;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    final user = authMethods.getCurrentUser();
    authMethods.fetchAllUsers(user!).then((List<UserModel> userModel){
      setState(() {
        userList = userModel;
        print("AAAA:$userList");
      });
    });
    sender = UserModel(uid: authMethods.getCurrentUser()?.uid, name: authMethods.getCurrentUser()?.displayName, profilePhoto: authMethods.getCurrentUser()?.photoURL);
  }

  getToken(){
    callMethods.getToken().then((value){
      setState(() {
        token=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemes.blackColor,
      height: 500,
      child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: CustomTitle(
                leading: CachedImage(
                  imageUrl: userList[index].profilePhoto?? Constant.cacheImage,
                  isRound: true,
                  radius: 45,
                ),
                mini: false,
                onTap: (){
                  setState(() {
                    log = Log(
                        callerName: Constant.displayName,
                        callerPic: authMethods.getCurrentUser()?.photoURL,
                        callStatus: Constant.CALL_STATUS_DIALLED,
                        receiverName: userList[index].name,
                        receiverPic: userList[index].profilePhoto,
                        timestamp: DateTime.now().toString(),
                        receiverId: userList[index].uid,
                        callerId: authMethods.getCurrentUser()?.uid
                    );
                  });
                  CallUtils.dial(from: sender, to: userList[index], context: context,token: token!,log: log!);
                },
                title: Text(
                  userList[index].name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppThemes.colorWhite
                  ),
                ),
                subtitle: Text(
                  userList[index].email!,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppThemes.colorWhite
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
