import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/screen/chat_screen/chat_detail.dart';

import '../../component/custom_title.dart';
import '../../resources/auth_methods.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthMethods authMethods = AuthMethods();

  late List<UserModel> userList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = authMethods.getCurrentUser();
    authMethods.fetchAllUsers(user!).then((List<UserModel> userModel){
      userList = userModel;
      print("AAAA:$userList");
    });
  }

  searchAppBar(BuildContext context) {
    return NewGradientAppBar(
      gradient: const LinearGradient(
        colors: [AppThemes.gradientColorStart,AppThemes.gradientColorEnd],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: AppThemes.blackColor,
            autofocus: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList.where((UserModel user) {
      String _getUsername = user.username!.toLowerCase();
      String _query = query.toLowerCase();
      String _getName = user.name!.toLowerCase();
      bool matchesUsername = _getUsername.contains(_query);
      bool matchesName = _getName.contains(_query);

      return (matchesUsername || matchesName);

      // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
      //     (user.name.toLowerCase().contains(query.toLowerCase()))),
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserModel searchedUser = UserModel(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);

        return CustomTitle(
          mini: false,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatDetail(receiver: searchedUser)));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto ?? Constant.cacheImage),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name!,
            style: const TextStyle(color: AppThemes.greyColor),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}
