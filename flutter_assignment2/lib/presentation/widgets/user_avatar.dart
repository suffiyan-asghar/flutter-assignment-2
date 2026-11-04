import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final int userId;
  final double radius;

  const UserAvatar({super.key, required this.userId, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      child: Text(
        'U$userId',
        style: TextStyle(
          color: colors.onPrimaryContainer,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
