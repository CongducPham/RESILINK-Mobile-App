import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/common/widget/default_pop_up.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/publish/provider/publish_provider.dart';
import 'package:resilink_design/features/publish/screen/contact_info.dart';
import 'package:resilink_design/features/publish/screen/offer_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../home_navigation/provider/home_navigation_provider.dart';
import '../../search/widget/assetType_ card.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return PublishScreenState();
  }

}

class PublishScreenState extends State<PublishScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PublishProvider(TextEditingController(text: ""), TextEditingController(text: ""), TextEditingController(text: ""), TextEditingController(text: ""), AppLocalizations.of(context)!.firstTypeTransaction, [AppLocalizations.of(context)!.firstTypeTransaction, AppLocalizations.of(context)!.secondTypeTransaction]),
      builder: (context, child) {
          return SingleChildScrollView(
            child: Consumer<PublishProvider>(
              builder: (context, publishProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                    Text(
                      AppLocalizations.of(context)!.publishFirstTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)!.publishFirstText,
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    SizedBox(height: 15),
                    Consumer<PublishProvider>(
                      builder: (context, publishProvider, child) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: context.read<HomeNavigationProvider>().allAssetType.keys.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: MediaQuery.of(context).size.width * 0.2,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: AssetTypeCard(label: context.read<HomeNavigationProvider>().allAssetType.keys.toList()[index], icon: Icons.add_alarm_outlined, parentContext: context, publishProvider: publishProvider,)
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Consumer<PublishProvider>(
                      builder: (context, publishProvider, child) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return DropdownButtonFormField<String>(
                                alignment: AlignmentDirectional.topStart,
                                elevation: 0,
                                value: publishProvider.offerTransactionType,
                                onChanged: (newValue) {
                                  publishProvider.setOfferTransaction(newValue!);
                                },
                                style: TextStyle(fontSize: 13, color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                  labelText: AppLocalizations.of(context)!.publishLabelChooseTransaction,
                                  labelStyle: const TextStyle(
                                    color: GlobalVariables.tersiaryColor,
                                    fontSize: 16.0,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(color: GlobalVariables.tersiaryColor, width: 2.0),
                                  ),
                                ),
                                dropdownColor: GlobalVariables.navigationBarColor,
                                items: publishProvider.offerTransactionTypeList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return TextFormField(
                            controller: publishProvider.offerName,
                            textAlignVertical: TextAlignVertical.bottom,
                            onChanged: (value) {
                              publishProvider.checkFormValidity();
                            },
                            style: TextStyle(
                                fontSize: 13
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.publishHinderLabelTitle,
                              labelText: AppLocalizations.of(context)!.publishLabelTitle,
                              labelStyle: const TextStyle(
                                color: GlobalVariables.tersiaryColor,
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(color: GlobalVariables.tersiaryColor, width: 2.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return TextFormField(
                            controller: publishProvider.offerLocalisation,
                            textAlignVertical: TextAlignVertical.bottom,
                            onChanged: (value) {
                              publishProvider.checkFormValidity();
                            },
                            style: TextStyle(
                                fontSize: 13
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.hinderTextLocalisation,
                              prefixIcon: IconButton(
                                icon: Icon(
                                    Icons.near_me_outlined, size: constraints.maxHeight * 0.5
                                ),
                                onPressed: () {
                                  publishProvider.offerLocalisation.text = "Pau";
                                  publishProvider.checkFormValidity();
                                },
                              ),
                              labelText: AppLocalizations.of(context)!.hinderTextLocalisation,
                              labelStyle: const TextStyle(
                                color: GlobalVariables.tersiaryColor,
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(color: GlobalVariables.tersiaryColor, width: 2.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<PublishProvider> (
                      builder: (context, publishProvider, child) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                publishProvider.setContactInfoActive(!publishProvider.contactInfoActive);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.publishContactInformation,
                                      style: TextStyle(
                                          color: GlobalVariables.tersiaryColor
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: GlobalVariables.tersiaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (publishProvider.contactInfoActive)
                              ContactInfo(),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                if (publishProvider.isFormValid)
                                  publishProvider.setOptionActive(!publishProvider.optionActive);
                              },
                              child: Opacity(
                                opacity: !publishProvider.isFormValid ? 0.3 : 1,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.publishMoreDetails,
                                        style: TextStyle(
                                            color: GlobalVariables.tersiaryColor
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: GlobalVariables.tersiaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (publishProvider.isFormValid && publishProvider.optionActive)
                              OfferOption(publishProvider: publishProvider),
                            SizedBox(height: 15),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Opacity(
                                  opacity: !publishProvider.isFormValid ? 0.3 : 1,
                                  child: IgnorePointer(
                                      ignoring: !publishProvider.isFormValid,
                                      child: DefaultButton(label: AppLocalizations.of(context)!.buttonPublish, parentContext: context, function: () {DefaultPopUp.show(this.context, "Offer Published", "Your offer will be published within an hour", "close");} , futureFunction: null)
                                  )
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
      },
    );
  }

}