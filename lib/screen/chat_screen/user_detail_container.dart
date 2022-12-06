import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/user.dart';

import '../../component/app_utils.dart';
import '../../component/cache_image.dart';
import '../../component/custom_appbar.dart';
import '../../enum/user_state.dart';
import '../../enum/view_state.dart';
import '../../logic/image_provider.dart';
import '../../logic/user_provider.dart';
import '../../resources/auth_methods.dart';
import '../../resources/storage_methods.dart';
import '../login.dart';

class UserDetailsContainer extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  UserDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    signOut() async {
      final bool isLoggedOut = await authMethods.signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        authMethods.setUserState(
          userId: userProvider.getUser!.uid!,
          userState: UserState.Offline,
        );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 45),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: const Text("User"),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () => signOut(),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          UserDetailsBody(userId: userProvider.getUser!.uid!),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatefulWidget {
  final String userId;

  const UserDetailsBody({super.key, required this.userId});

  @override
  State<UserDetailsBody> createState() => _UserDetailsBodyState();
}

class _UserDetailsBodyState extends State<UserDetailsBody> {
  final StorageMethods storageMethods = StorageMethods();
  final AuthMethods authMethods = AuthMethods();
  late ImageUploadProvider imageUploadProvider;

  void pickImage({required ImageSource source}) async {
    File selectedImage = await AppUtils.pickImage(source: source);
    storageMethods.uploadAvatar(image: selectedImage, imageUploadProvider: imageUploadProvider, userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserModel user = userProvider.getUser!;
    imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return StreamBuilder(
      stream: authMethods.getUserStream(uid: user.uid!),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return imageUploadProvider.getViewState == ViewState.LOADING
            ? Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 15),
                child: const CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => pickImage(source: ImageSource.camera),
                      child: CachedImage(
                        imageUrl: user.profilePhoto ?? Constant.cacheImage,
                        isRound: true,
                        radius: 50,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.email!,
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }
}
