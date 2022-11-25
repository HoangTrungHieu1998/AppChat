import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final VoidCallback? helpOnTap;
  final ValueChanged<String>? onChange;
  final TextEditingController? controller;
  final Widget? helpContent;

  AppTextField({
    required this.icon,
    required this.hint,
    this.helpOnTap,
    this.helpContent,
    this.onChange,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            prefixIcon: Icon(icon),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
          ),
        ),
        if (helpContent != null && helpOnTap != null)
          SizedBox(
            height: 48,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: helpOnTap,
                child: helpContent,
              ),
            ),
          )
      ],
    );
  }
}