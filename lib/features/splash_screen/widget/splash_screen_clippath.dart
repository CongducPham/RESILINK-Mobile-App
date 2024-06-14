// Define your custom shape by extending CustomClipper<Path>
import 'package:flutter/material.dart';

class CustomImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(-10, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width + 10, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // If you change the shape, set this to true
  }
}