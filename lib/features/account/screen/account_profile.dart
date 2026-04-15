import 'package:resilink_mobile_application/features/account/provider/accountData_provider.dart';
import 'package:resilink_mobile_application/features/account/screen/password_changing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/features/account/provider/account_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../common/widget/textfield_info.dart';
import '../../../constants/global_variables.dart';
import '../../../providers/main_provider.dart';

class AccountProfile extends StatefulWidget {
  AccountProfile({super.key, required this.parentContext, required this.accountProvider});

  BuildContext parentContext;
  AccountProvider accountProvider;

  @override
  State<StatefulWidget> createState() => AccountProfileState();
}

class AccountProfileState extends State<AccountProfile> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountDataProvider(
        context,
        id: context.read<MainProvider>()?.actualUser?.id ?? "",
        username: context.read<MainProvider>()?.actualUser?.username ?? "",
        firstname: context.read<MainProvider>()?.actualUser?.firstName ?? "",
        lastname: context.read<MainProvider>()?.actualUser?.lastName ?? "",
        email: context.read<MainProvider>()?.actualUser?.email ?? "",
        activityDomain: context.read<MainProvider>()?.actualProsumer?.activityDomain ?? "",
        activityProfession: context.read<MainProvider>()?.actualProsumer?.specificActivity ?? "",
        phoneNumber: context.read<MainProvider>()?.actualUser?.phoneNumber ?? "",
        location: context.read<MainProvider>()?.actualProsumer?.location ?? "",
        gps: context.read<MainProvider>()?.actualUser?.gps ?? "",
      ),
      builder: (context, child) {
        return Consumer<AccountDataProvider>(
          builder: (context, accountDataProvider, child) {
            return Column(
              key: context.read<AccountProvider>().profileKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── PROFILE TITLE ───────────────────────────────────────
                Text(
                  AppLocalizations.of(context)!.accountProfileTitle,
                  // titleMedium (16, w500) + override bold
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ── PROFILE FIELDS ──────────────────────────────────────
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.id,
                    label: AppLocalizations.of(context)!.accountLabelPrivateId,
                    parentContext: context,
                    isNumeric: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.firstname,
                    label: AppLocalizations.of(context)!.accountLabelFirstname,
                    parentContext: context,
                    isNumeric: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.lastname,
                    label: AppLocalizations.of(context)!.accountLabelLastname,
                    parentContext: context,
                    isNumeric: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.username,
                    label: AppLocalizations.of(context)!.accountLabelUsername,
                    parentContext: context,
                    isNumeric: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.location,
                    label: AppLocalizations.of(context)!.accountLabelLocation,
                    parentContext: context,
                    isNumeric: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.phoneNumber,
                    label: AppLocalizations.of(context)!.labelPhoneNumber,
                    parentContext: context,
                    isNumeric: true,
                  ),
                ),

                // ── DROPDOWNS ───────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 5),
                  child: DropdownButtonFormField<String>(
                    value: accountDataProvider.activityDomain,
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
                        borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(color: GlobalVariables.tertiaryColor, width: 2.0),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                    ),
                    items: accountDataProvider.activityDomainCodes.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Text(
                          accountDataProvider.translateDomain(context, code),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      );
                    }).toList(),
                    onChanged: (code) {
                      accountDataProvider.setFieldSpecialization(context, code!);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 5),
                  child: DropdownButtonFormField<String>(
                    value: accountDataProvider.activityProfession,
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
                        borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(color: GlobalVariables.tertiaryColor, width: 2.0),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                    ),
                    items: accountDataProvider.activityProfessionCodes[accountDataProvider.activityDomain]!.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Text(
                          accountDataProvider.translateProfession(context, code),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      );
                    }).toList(),
                    onChanged: (code) {
                      accountDataProvider.setActivityProfession(code!);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFieldInfo(
                    textController: accountDataProvider.email,
                    label: AppLocalizations.of(context)!.labelEmail,
                    parentContext: context,
                    isNumeric: false,
                  ),
                ),
                const SizedBox(height: 10),

                // ── GPS FIELD ───────────────────────────────────────────
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: accountDataProvider.gps,
                          textAlignVertical: TextAlignVertical.bottom,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onTap: accountDataProvider.gps.text.isEmpty
                              ? () async => await accountDataProvider.setLocalisation()
                              : null,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: AppLocalizations.of(context)!.accountProfileGpsHintText,
                            prefixIcon: Icon(Icons.near_me_outlined, size: constraints.maxHeight * 0.5),
                            suffixIcon: accountDataProvider.gps.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(Icons.clear, size: constraints.maxHeight * 0.4),
                              onPressed: () => accountDataProvider.clearGps(),
                            )
                                : null,
                            labelText: AppLocalizations.of(context)!.publishLabelLocalisation,
                            labelStyle: const TextStyle(
                              color: GlobalVariables.tertiaryColor,
                              fontSize: 16.0,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(color: GlobalVariables.tertiaryColor, width: 2.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ── ACTIONS ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultButton(
                      label: AppLocalizations.of(context).buttonTitleChangePassword,
                      parentContext: context,
                      function: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordChanging())),
                      futureFunction: null,
                    ),
                    DefaultButton(
                      label: AppLocalizations.of(context)!.buttonModify,
                      parentContext: context,
                      function: null,
                      futureFunction: () => accountDataProvider.updateUserData(context),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}