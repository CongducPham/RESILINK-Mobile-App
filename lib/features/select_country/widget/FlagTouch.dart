import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/splash_screen/screen/splash_screen.dart';
import 'package:Resilink/providers/main_provider.dart';

// Provides a method to create a country flag button that sets the selected country and navigates to the SplashScreen.
class FlagTouch {

  // Creates a button with a country flag and label.
  // Sets the selected country and navigates to the SplashScreen on tap.
  Widget flagTouchNavigator(String text, String imageKey, double maxWidth, double maxHeight, BuildContext context, String country, bool fromParameter) {
    return GestureDetector(
      onTap: () async {
        await context.read<MainProvider>().setCountry(country);
        if (fromParameter) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
        }
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SvgPicture.network(
              country == "Morocco" ? "https://upload.wikimedia.org/wikipedia/commons/2/2c/Flag_of_Morocco.svg"
                  : country == "Algeria" ? "https://upload.wikimedia.org/wikipedia/commons/7/77/Flag_of_Algeria.svg"
                  : "https://upload.wikimedia.org/wikipedia/commons/f/fe/Flag_of_Egypt.svg",
              fit: BoxFit.cover,
              width: maxWidth * 0.5,
              height: maxHeight * 0.2,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

}
