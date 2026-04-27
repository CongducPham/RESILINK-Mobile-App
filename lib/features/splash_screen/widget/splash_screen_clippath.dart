/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
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