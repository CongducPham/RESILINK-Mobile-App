import 'package:flutter/material.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/features/home_navigation/screen/home_navigation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../widget/splash_screen_clippath.dart';

// A splash screen widget that serves as the introductory screen of the application.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Function to navigate to the main home screen when the button is pressed.
    void navigateToNextScreen() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeNavigation())
      );
    }

    return SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Container that holds the splash art image and a custom clip path.
                    Container(
                        height: constraints.maxHeight * 0.70,
                        width: constraints.maxWidth,
                        child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // The splash art image that fills the top portion of the screen.
                              Image(
                                width: constraints.maxWidth,
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    GlobalVariables.othersImage['splashArt']!
                                ),
                              ),
                              // A custom white wave shape at the bottom of the image.
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
                            ]
                        )
                    ),
                    // Container that holds the logo, text, and navigation button.
                    Container(
                      height: constraints.maxHeight * 0.3,
                      child: Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.02),
                          // The app's logo displayed below the splash art.
                          Image(
                              height: constraints.maxHeight * 0.055,
                              image: AssetImage(GlobalVariables.othersImage['resilinkLogo']!)
                          ),
                          SizedBox(height: constraints.maxHeight * 0.035),
                          Text(
                              AppLocalizations.of(context)!.splashscreenText,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                              )
                          ),
                          SizedBox(height: constraints.maxHeight * 0.035),
                          // A button that navigates to the main home screen.
                          DefaultButton(
                              label: AppLocalizations.of(context)!.buttonStart,
                              parentContext: context,
                              function: navigateToNextScreen,
                              futureFunction: null
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
          ),
        )
    );
  }
}
