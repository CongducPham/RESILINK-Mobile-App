import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/splash_screen/screen/splash_screen.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

class CountryButton {
  Widget countryButton(String text, BuildContext context, String country, bool fromParameter) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async {
          await context.read<MainProvider>().setCountry(country);
          if (fromParameter) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.grey),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
