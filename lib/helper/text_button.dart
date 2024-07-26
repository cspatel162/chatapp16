import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final String text;
  final Color colors;

  const MyTextButton({super.key, required this.onPressed, required this.text, required this.colors, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 6)),
        onPressed: onPressed,
        child: Text(text, textAlign: TextAlign.start, style: TextStyle(color: colors, fontFamily: 'medium', fontSize: 14)),
      ),
    );
  }
}
