// Define your custom shape by extending CustomClipper<Path>
import 'package:flutter/material.dart';

class CustomImageClipper extends CustomClipper<Path> {

  // Generates the path that defines the custom shape.
  // This particular path creates a wave that spans the width of the container.
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start the path slightly off-screen to the left
    path.moveTo(-10, size.height);
    // Create a quadratic Bezier curve that peaks at the center of the container
    // and ends slightly off-screen to the right
    path.quadraticBezierTo(size.width / 2, 0, size.width + 10, size.height);
    return path;
  }

  @override
  // Determines whether the custom clip should be redrawn when the widget changes.
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // If you change the shape, set this to true
  }
}