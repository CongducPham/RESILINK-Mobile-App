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
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../common/widget/default_button.dart';
import '../../../features/onboarding/screen/onboarding_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../widget/splash_screen_clippath.dart';

// A splash screen widget that serves as the introductory screen of the application.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Navigates to the onboarding screen when the button is pressed.
    void navigateToNextScreen() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Container holding the splash art image and a custom clip path.
                Container(
                  height: constraints.maxHeight * 0.70,
                  width: constraints.maxWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Splash art image filling the top portion of the screen.
                      Image(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * 0.70,
                        fit: BoxFit.cover,
                        image: AssetImage(GlobalVariables.othersImage['splashArt']!),
                      ),
                      // Custom white wave shape at the bottom of the image.
                      Positioned(
                        bottom: -0.2,
                        child: ClipPath(
                          clipper: CustomImageClipper(),
                          child: Container(
                            height: constraints.maxHeight * 0.15,
                            width: constraints.maxWidth,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container holding the logo, tagline text, and navigation button.
                Container(
                  height: constraints.maxHeight * 0.3,
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.02),
                      // App logo displayed below the splash art.
                      Image(
                        height: constraints.maxHeight * 0.055,
                        image: AssetImage(GlobalVariables.othersImage['resilinkLogo']!),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.035),
                      // Tagline text — titleLarge for a prominent but not oversized label
                      Text(
                        AppLocalizations.of(context)!.splashscreenText,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.035),
                      // Button that navigates to the onboarding screen.
                      DefaultButton(
                        label: AppLocalizations.of(context)!.buttonStart,
                        parentContext: context,
                        function: navigateToNextScreen,
                        futureFunction: null,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}