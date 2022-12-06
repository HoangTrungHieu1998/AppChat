import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/screen/home.dart';
import 'package:skype_clone/screen/login.dart';

import '../resources/auth_methods.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  double _start = 2;
  late AuthMethods authMethods;
  CameraController? cameraController;

  void startTimer() {
    const oneSec = Duration(milliseconds: 500);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            authMethods = AuthMethods();
            if(authMethods.getCurrentUser() == null){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginScreen()));
            }else{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen()));
            }

          });
        } else {
          setState(() {
            _start-= 0.5;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.blackNature,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                "assets/images/company_logo.png",
                height: 250,
              ),
              const SizedBox(height: 100),
              Shimmer.fromColors(
                  baseColor: Colors.green,
                  highlightColor: Colors.red,
                  child: const Text(
                    "Pigeon",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 62,
                    ),
                  )
              ),
              const SizedBox(height: 100),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}