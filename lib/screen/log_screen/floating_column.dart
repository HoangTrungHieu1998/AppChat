import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';

class FloatingColumn extends StatelessWidget {
  const FloatingColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppThemes.fabGradient,
          ),
          padding: const EdgeInsets.all(15),
          child: const Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(height: 15),
        Container(
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
        )
      ],
    );
  }
}