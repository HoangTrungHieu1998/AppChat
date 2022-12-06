import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/screen/log_screen/search_call.dart';

import '../../component/skype_appbar.dart';
import '../call_screens/pickup/pickup_layout.dart';
import '../chat_screen/user_detail_container.dart';
import 'floating_column.dart';
import 'log_list_container.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: AppThemes.blackColor,
        appBar: SkypeAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: AppThemes.blackColor,
            builder: (context) => const SearchCall(),
          ),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppThemes.blackColor,
                border: Border.all(
                  width: 2,
                  color: AppThemes.gradientColorEnd,
                )),
            padding: const EdgeInsets.all(15),
            child: const Icon(
              Icons.add_call,
              color: AppThemes.gradientColorEnd,
              size: 25,
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
