import 'package:flutter/material.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/features/home_navigation/screen/home_navigation_screen.dart';

import '../../../constants/global_variables.dart';
import '../widget/splash_screen_clippath.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    void navigateToNextScreen() {
      print("in");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeNavigation()));
    }

    return SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                      height: constraints.maxHeight * 0.70,
                      width: constraints.maxWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            width: constraints.maxWidth,
                            fit: BoxFit.cover,
                            image: AssetImage(
                                GlobalVariables.othersImage['splashArt']!
                            ),
                          ),
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
                  Container(
                    height: constraints.maxHeight * 0.3,
                    child: Column(
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Image(
                          height: constraints.maxHeight * 0.055,
                          image: AssetImage(GlobalVariables.othersImage['resilinkLogo']!)
                        ),
                        SizedBox(height: constraints.maxHeight * 0.035),
                        Text(
                          'Promote local resources sharing',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          )
                        ),
                        SizedBox(height: constraints.maxHeight * 0.035),
                        DefaultButton(label: "ee", parentContext: context, function: navigateToNextScreen, futureFunction: null)
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