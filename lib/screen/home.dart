import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/component/app_icon.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/logic/user_provider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screen/call_screens/pickup/pickup_layout.dart';
import 'package:skype_clone/screen/chat_screen/chat_screen.dart';
import 'package:skype_clone/screen/log_screen/log_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late PageController pageController;
  int _page = 0;
  final AuthMethods authMethods = AuthMethods();

  late UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      userProvider = Provider.of<UserProvider>(context,listen: false);
      await userProvider.refreshUser();

      authMethods.setUserState(
          userId: userProvider.getUser!.uid!,
          userState: UserState.Online
      );
      
      LogRepository().init(isHive: true, dbName: userProvider.getUser!.uid!);
      
    });

    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    String currentUserId =
    (userProvider != null && userProvider.getUser != null)
        ? userProvider.getUser!.uid!
        : "";
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? authMethods.setUserState(
            userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? authMethods.setUserState(
            userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChange(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
          backgroundColor: AppThemes.blackColor,
          body: PageView(
            controller: pageController,
            onPageChanged: onPageChange,
            physics: const NeverScrollableScrollPhysics(),
            children: const[
              ChatScreen(),
              LogScreen(),
              Center(child: Text("Chat"),),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              currentIndex: _page,
              onTap: navigationTapped,
              backgroundColor: AppThemes.blackColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(AppIcons.chat,color: _page==0 ? AppThemes.lightBlueColor:AppThemes.greyColor,),
                    label: "Chat"
                ),
                BottomNavigationBarItem(
                    icon: Icon(AppIcons.phone,color: _page==1 ? AppThemes.lightBlueColor:AppThemes.greyColor,),
                    label: "Call"
                ),
                BottomNavigationBarItem(
                    icon: Icon(AppIcons.contact,color: _page==2 ? AppThemes.lightBlueColor:AppThemes.greyColor,),
                    label: "Contact"
                ),
              ],
            ),
          ),
        )
    );
  }
}
