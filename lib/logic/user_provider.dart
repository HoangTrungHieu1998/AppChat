import 'package:flutter/material.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/auth_methods.dart';


class UserProvider with ChangeNotifier {
  UserModel? _user;
  AuthMethods authMethods = AuthMethods();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}