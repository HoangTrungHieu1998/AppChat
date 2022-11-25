import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/logic/image_provider.dart';
import 'package:skype_clone/logic/user_provider.dart';
import 'package:skype_clone/screen/splash_screen.dart';

import 'const.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          appId: Constant.appID,
          apiKey: Constant.apikey,
          messagingSenderId: Constant.senderId,
          projectId: Constant.projectId,
          storageBucket: Constant.storageBucket
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp

  ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ImageUploadProvider()),
        ChangeNotifierProvider(create: (_)=>UserProvider()),
      ],
      child: MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    ),
    );
  }
}
