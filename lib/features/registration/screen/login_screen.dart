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
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/common/widget/textfield_info.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/features/registration/provider/login_provider.dart';
import 'package:resilink_mobile_application/features/registration/screen/sign_up_screen.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {

    // local variable for screen size
    double h = MediaQuery.of(context).size.height;

    return SizedBox(
      height: h,
      child: SingleChildScrollView(

        // Using BouncingScrollPhysics so that scrolling does not increase screen size in a predefined way
        physics: const BouncingScrollPhysics(),
        child: ChangeNotifierProvider(

          // Creating the Login provider in the tree structure
          create: (_) => LoginProvider(),
          builder: (context, child) {
            return Consumer3<LoginProvider, MainProvider, HomeNavigationProvider>( // Listening to Login, HomeNavigation and Main providers to access their data
              builder: (context, loginProvider, userProvider, homeNavigationProvider, child) {
                return Column( // Column with text fields for user id and password, an access to the registration page and a button to confirm user registration
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: h * 0.1),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                          AppLocalizations.of(context)!.registerLoginTitle,
                          style: Theme.of(context).textTheme.displaySmall
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        TextFieldInfo(textController: loginProvider.username, label: AppLocalizations.of(context)!.registerLoginFirstLabel, parentContext: context, isNumeric: false,),
                        TextFieldInfo(textController: loginProvider.password, label: AppLocalizations.of(context)!.registerLoginSecondLabel, parentContext: context, isNumeric: false, obscureText: true)
                      ],
                    ),

                    // If something has gone wrong, a warning is displayed
                    if (loginProvider.error)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          AppLocalizations.of(context)!.registerLoginErrorConnexion,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.red
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),

                    // Login button
                    Container(
                        alignment: Alignment.bottomRight,
                        child: DefaultButton(
                            label: AppLocalizations.of(context)!.buttonSignIn,
                            parentContext: context, function: null,
                            futureFunction: () => loginProvider.signIn(context, userProvider, homeNavigationProvider)
                        )
                    ),

                    // textButton equivalent to access registration page
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(homeNavigationProvider: homeNavigationProvider,)));
                        },
                        child: Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                              AppLocalizations.of(context)!.registerLoginRedirection,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.lightBlueAccent)
                          ),
                        )
                    ),
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }

}
