import 'package:flutter/material.dart';

class AvatarWithInitials extends StatelessWidget {
  final String initials;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const AvatarWithInitials({
    super.key,
    required this.initials,
    this.radius = 20,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
}