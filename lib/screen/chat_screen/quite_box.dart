import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/screen/chat_screen/search_screen.dart';

class QuietBox extends StatelessWidget {
  final String? heading;
  final String? subtitle;

  const QuietBox({super.key, this.heading, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: AppThemes.separatorColor,
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading??"",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                subtitle??"",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              RawMaterialButton(
                fillColor: AppThemes.lightBlueColor,
                child: const Text("START SEARCHING"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}