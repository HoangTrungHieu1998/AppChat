import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Welcome",style: TextStyle(fontSize: 40),),
        ),
      ),
    );
  }
}