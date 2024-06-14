import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/features/account/provider/account_provider.dart';

import '../../../common/widget/textfield_info.dart';

class AccountProfile extends StatefulWidget {
  AccountProfile({super.key, required this.parentContext});

  BuildContext parentContext;

  @override
  State<StatefulWidget> createState() {
    return AccountProfileState();
  }

}

class AccountProfileState extends State<AccountProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Profile",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(label: "Modify", parentContext: context, function: null, futureFunction: null),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  DefaultButton(label: "Delete", parentContext: context, function: null, futureFunction: null),
                ],
              )
            )
          ],
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().firstname, label: "First name", parentContext: context)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().lastname, label: "Last Name", parentContext: context)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().username, label: "Username", parentContext: context)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().location, label: "Location", parentContext: context)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().phoneNumber, label: "Phone number", parentContext: context)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().job, label: "job", parentContext: context)),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: TextFieldInfo(textController: context.read<AccountProvider>().email, label: "Email", parentContext: context)),
      ],
    );
  }

}