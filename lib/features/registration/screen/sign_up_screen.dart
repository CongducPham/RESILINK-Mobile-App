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
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../../../providers/main_provider.dart';
import '../provider/sign_up_provider.dart';


// Registration widget, widget displaying the registration page. Page separate from main navigation

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key, required this.homeNavigationProvider});

  HomeNavigationProvider homeNavigationProvider;
  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }

}

class SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Material(
              color: GlobalVariables.headerBackgroundColor,
              elevation: 4,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    AppLocalizations.of(context)!.registerSignUpTitle,
                    style: const TextStyle(color: GlobalVariables.textHeaderColor),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ChangeNotifierProvider(
                create: (_) => SignUpProvider(context),
                builder: (context, child) {
                  return Consumer2<SignUpProvider, MainProvider>( // Listening to SignUp and Main providers to access their data
                    builder: (context, signUpProvider, mainProvider, child) {

                      if (signUpProvider.activityDomain.isEmpty) {
                        signUpProvider.setActivityDomain(context);
                        signUpProvider.setFieldSpecialization(context, signUpProvider.activityDomain);
                      }

                      return Container(
                        margin: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                        height: MediaQuery.of(context).size.height,
                        child: Column( // Column with text fields for user data, a second access to the login page and a button to confirm user registration
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10, bottom: 15),
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: TextFieldInfo(textController: signUpProvider.firstname, label: "${AppLocalizations.of(context)!.accountLabelFirstname} *", parentContext: context, isNumeric: false,)),
                                Flexible(flex: 1, child: Container()),
                                Container(
                                    margin: const EdgeInsets.only(left: 10, bottom: 15),
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: TextFieldInfo(textController: signUpProvider.lastname, label: "${AppLocalizations.of(context)!.accountLabelLastname} *", parentContext: context, isNumeric: false,)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10, bottom: 15),
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: TextFieldInfo(textController: signUpProvider.username, label: "${AppLocalizations.of(context)!.accountLabelUsername} *", parentContext: context, isNumeric: false,)),
                                Flexible(flex: 1, child: Container()),
                                Container(
                                    margin: const EdgeInsets.only(left: 10, bottom: 15),
                                    width: MediaQuery.of(context).size.width * 0.35,

                                    child: TextFieldInfo(textController: signUpProvider.phoneNumber, label: "${AppLocalizations.of(context)!.labelPhoneNumber} *", parentContext: context, isNumeric: true,))
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: DropdownButtonFormField<String>(
                                    value: signUpProvider.activityDomain,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                      labelText: AppLocalizations.of(context)!.activityDomain,
                                      labelStyle: const TextStyle(
                                        color: GlobalVariables.tertiaryColor,
                                        fontSize: 16.0,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                          color: GlobalVariables.unFocusBorderColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                          color: GlobalVariables.tertiaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.black,
                                    ),
                                    items: signUpProvider.activityDomainCodes.map((code) {
                                      return DropdownMenuItem(
                                        value: code,
                                        child: Text(
                                            signUpProvider.translateDomain(context, code),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (code) {
                                      signUpProvider.setFieldSpecialization(context, code!);
                                    },
                                  )
                                ),
                                Flexible(flex: 1, child: Container()),
                                Container(
                                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: DropdownButtonFormField<String>(
                                    value: signUpProvider.activityProfession,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                      labelText: AppLocalizations.of(context)!.fieldSpecialization,
                                      labelStyle: const TextStyle(
                                        color: GlobalVariables.tertiaryColor,
                                        fontSize: 16.0,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                          color: GlobalVariables.unFocusBorderColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                          color: GlobalVariables.tertiaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.black,
                                    ),
                                    items: signUpProvider.activityProfessionCodes[signUpProvider.activityDomain]!.map((code) {
                                      return DropdownMenuItem(
                                        value: code,
                                        child: Text(
                                          signUpProvider.translateProfession(context, code),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (code) {
                                      signUpProvider.setActivityProfession(code!);
                                    },
                                  )
                                ),
                              ],
                            ),
                           Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: TextFieldInfo(textController: signUpProvider.email, label: "${AppLocalizations.of(context)!.labelEmail} *", parentContext: context, isNumeric: false,)),
                            TextFieldInfo(textController: signUpProvider.password, label: "${AppLocalizations.of(context)!.registerLoginSecondLabel} *", parentContext: context, isNumeric: false, obscureText: true),

                            if (context.watch<SignUpProvider>().error && signUpProvider.password.text.length < 6)
                              Container(
                                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!.registerSignUpErrorPassword,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Colors.red
                                        )),
                                  )
                              ),

                            // Registration button
                            Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: DefaultButton(
                                    label: AppLocalizations.of(context)!.buttonSignUp,
                                    parentContext: context, function: null,
                                    futureFunction: () => signUpProvider.signUp(context, mainProvider, widget.homeNavigationProvider)
                                )
                            ),
                            const SizedBox(height: 10),

                            // textButton equivalent to access login page
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.registerSignUpRedirection,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Colors.lightBlueAccent
                                    )
                                )
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
        ),
      );
  }
}