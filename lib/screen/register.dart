import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/app_button.dart';
import '../component/app_icon.dart';
import '../component/app_textfield.dart';
import '../component/app_theme.dart';
import '../resources/auth_methods.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthMethods authMethods = AuthMethods();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();


  String email = "";
  String password = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/register.png",
                  height: 250,
                ),
              ),
              const Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppThemes.colorHeader,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 24),
              AppTextField(
                hint: "Full Name",
                icon: AppIcons.user,
                controller: nameController,
                onChange: (value){
                  name = value;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                hint: "Email",
                icon: AppIcons.email,
                controller: emailController,
                onChange: (value){
                  email = value;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                hint: "Password",
                icon: AppIcons.lock,
                controller: passController,
                onChange: (value){
                  password = value;
                },
              ),
              const SizedBox(height: 42),
              RawMaterialButton(
                fillColor: AppThemes.colorPrimary,
                padding: const EdgeInsets.all(16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                onPressed: () =>registerWithEmailPassword(),
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 42),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppThemes.colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void registerWithEmailPassword(){
    authMethods.registerWithEmailPassword(email, password).then((UserCredential? user){
      if(user !=null){
        authentication(user);
      }else{
        print("Register Fail");
      }
    });
  }

  void authentication(UserCredential user) {
    authMethods.authenticateUser(user).then((isNewUser){
      if(isNewUser){
        authMethods.addDataToDB(user:user,username: name).then((value)
        => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen())));
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }
    });
  }
}
