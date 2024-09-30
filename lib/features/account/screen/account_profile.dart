import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/features/account/provider/account_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/widget/textfield_info.dart';

// Widget, part of the account page, displays profile information and allows modifications.
class AccountProfile extends StatefulWidget {
  AccountProfile({super.key, required this.parentContext, required this.accountProvider});

  BuildContext parentContext;
  AccountProvider accountProvider;

  @override
  State<StatefulWidget> createState() {
    return AccountProfileState();
  }

}

class AccountProfileState extends State<AccountProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: context.read<AccountProvider>().profileKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.accountProfileTitle,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
          ),
        ),

        // List of user information
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().firstname, label: AppLocalizations.of(context)!.accountLabelFirstname, parentContext: context, isNumeric: false,)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().lastname, label: AppLocalizations.of(context)!.accountLabelLastname, parentContext: context, isNumeric: false,)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().username, label: AppLocalizations.of(context)!.accountLabelUsername, parentContext: context, isNumeric: false,)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().location, label: AppLocalizations.of(context)!.accountLabelLocation, parentContext: context, isNumeric: false,)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().phoneNumber, label: AppLocalizations.of(context)!.labelPhoneNumber, parentContext: context, isNumeric: true,)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().job, label: AppLocalizations.of(context)!.accountLabelJob, parentContext: context, isNumeric: false,)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().email, label: AppLocalizations.of(context)!.labelEmail, parentContext: context, isNumeric: false,)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            // Button to call up the profile information update function
            DefaultButton(label: AppLocalizations.of(context)!.buttonModify, parentContext: context, function: null, futureFunction: () => widget.accountProvider.updateUserData(context)),
          ],
        ),
      ],
    );
  }

}