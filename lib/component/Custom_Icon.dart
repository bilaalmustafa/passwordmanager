import 'package:flutter/material.dart';

class customIcon extends StatelessWidget {
  const customIcon({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white60,
      ),
    );
  }
}
