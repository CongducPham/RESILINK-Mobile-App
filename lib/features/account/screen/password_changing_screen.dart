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
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/main.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../common/widget/textfield_info.dart';
import '../../../constants/global_variables.dart';
import '../../../providers/locale_provider.dart';
import '../provider/password_changing_provider.dart';

class PasswordChanging extends StatefulWidget {
  const PasswordChanging({super.key});

  @override
  PasswordChangingState createState() => PasswordChangingState();
}

class PasswordChangingState extends State<PasswordChanging> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
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
                  AppLocalizations.of(context)!.passwordChanging,
                  style: const TextStyle(color: GlobalVariables.textHeaderColor),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (_) => PasswordChangingProvider(),
          builder: (context, child) {
            return Consumer<PasswordChangingProvider>(
              builder: (context, passwordChangingProvider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      // Sous-titre — titleMedium (16, w500) + override w600
                      Text(
                        AppLocalizations.of(context)!.passwordChangingSubTitle,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Texte explicatif — bodyMedium (14)
                      Text(
                        AppLocalizations.of(context)!.explanatoryTextPasswordChanging,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 50),
                      TextFieldInfo(
                        textController: passwordChangingProvider.oldPassword,
                        label: AppLocalizations.of(context)!.oldPassword,
                        parentContext: context,
                        isNumeric: false,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldInfo(
                        textController: passwordChangingProvider.newPassword,
                        label: AppLocalizations.of(context)!.newPassword,
                        parentContext: context,
                        isNumeric: false,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: DefaultButton(
                          label: AppLocalizations.of(context)!.buttonConfirm,
                          parentContext: context,
                          function: null,
                          futureFunction: () => passwordChangingProvider.updatePassword(context),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}