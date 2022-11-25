import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/component/app_utils.dart';
import 'package:skype_clone/logic/user_provider.dart';
import 'package:skype_clone/screen/chat_screen/user_detail_container.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: AppThemes.blackColor,
        builder: (context) => UserDetailsContainer(),
      ),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppThemes.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                AppUtils.getInitials(userProvider.getUser!.name, userProvider.getUser!.email!),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppThemes.lightBlueColor,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemes.blackColor, width: 2), color: AppThemes.onlineDotColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
