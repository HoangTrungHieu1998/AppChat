import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_icon.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/screen/home.dart';
import 'package:skype_clone/screen/register.dart';

import '../component/app_button.dart';
import '../component/app_textfield.dart';
import '../resources/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods authMethods = AuthMethods();
  late TapGestureRecognizer registerOnTap;
  final emailController = TextEditingController();
  final passController = TextEditingController();

  String email = "";
  String password = "";

  @override
  void initState() {
    registerOnTap = TapGestureRecognizer();
    registerOnTap
      .onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RegisterScreen(),
          ),
        );
      };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            Image.asset(
              "assets/images/skype.png",
              height: 250,
            ),
            const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppThemes.colorHeader,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              hint: "Email ID",
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
              helpContent: const Text(
                "Forgot?",
                style: TextStyle(fontSize: 16, color: AppThemes.colorPrimary),
              ),
              helpOnTap: () {},
            ),
            const SizedBox(height: 12),
            RawMaterialButton(
              fillColor: AppThemes.colorPrimary,
              padding: const EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              onPressed: () => signInEmailPassword(),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Or, login with...",
              style: TextStyle(color: Colors.black38),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/google.png",
                    onTap: () => signInGoogle(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/facebook.png",
                    onTap: () =>signInFacebook(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/apple.png",
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: "You don't have account? ",
                children: [
                  TextSpan(
                    text: "Register",
                    style: const TextStyle(
                      color: AppThemes.colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: registerOnTap,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }

  void signInGoogle(){
    authMethods.signInWithGoogle().then((UserCredential? user){
      if(user !=null){
        authentication(user);
      }
    });
  }

  void signInFacebook(){
    authMethods.signInWithFacebook().then((UserCredential? user){
      if(user !=null){
        authentication(user);
      }
    });
  }

  void signInEmailPassword(){
    authMethods.signInWithEmailPassword(email, password).then((UserCredential? user){
      if(user !=null){
        authentication(user);
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegisterScreen()));
      }
    });
  }

  void authentication(UserCredential user) {
    authMethods.authenticateUser(user).then((isNewUser){
      if(isNewUser){
        authMethods.addDataToDB(user).then((value)
        => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen())));
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }
    });
  }
}
