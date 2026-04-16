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
                // AppBar title → nothing to change ✅
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