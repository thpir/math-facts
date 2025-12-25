import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final String imagePath;
  final Function()? onPressed;
  const GameButton({super.key, required this.imagePath, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      onTap: onPressed,
      child: Image.asset(imagePath, width: 48, height: 48));
  }
}
