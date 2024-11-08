import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/publish/provider/publish_provider.dart';
import 'package:Resilink/features/publish/screen/contact_info.dart';
import 'package:Resilink/features/publish/screen/offer_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/providers/main_provider.dart';

import '../../../common/widget/textfield_info.dart';
import '../../home_navigation/provider/home_navigation_provider.dart';
import '../../search/widget/assetType_ card.dart';

// Offer publication page widget
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
      // Creating the Publish provider in the tree structure
    create: (_) => PublishProvider(
          assetToUpdate: context.read<MainProvider>()!.assetDetails,
          offerToUpdate: context.read<MainProvider>()!.offerDetails,
          offerTransactionTypeList: [AppLocalizations.of(context)!.firstTypeTransaction, AppLocalizations.of(context)!.secondTypeTransaction],
          context: context),
      builder: (context, child) {
          return Consumer2<PublishProvider, HomeNavigationProvider>( // Listening to Publish, HomeNavigation providers to access their data
            builder: (context, publishProvider, homeNavigationProvider, child) {
              return GestureDetector(
                onTap: publishProvider.unFocus,
                child: SingleChildScrollView(
                  child: Column(
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.publishFirstText,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black
                              ),
                            ),
                            TextSpan(
                              text: " *",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red
                              ),
                            ),
                          ]
                        ),
                      ),
                      SizedBox(height: 15),
                      // SizedBox to display/manage the offer assetTypes
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: publishProvider.assetTypeList.length,
                          itemBuilder: (context, index) {
                            return Container(
                                height: MediaQuery.of(context).size.width * 0.2,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: AssetTypeCard(label: publishProvider.getTradAssetType(publishProvider.assetTypeList[index], context), icon: (GlobalVariables.svgImage[publishProvider.assetTypeList[index].toLowerCase().replaceAll(' ', '')]!) , parentContext: context, publishProvider: publishProvider,)
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      // SizedBox to choose the transaction type (rent or purchase/sell)
                      SizedBox(
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
                                labelText: "${AppLocalizations.of(context)!.publishLabelChooseTransaction} *",
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
                      ),
                      SizedBox(height: 20),
                      // SizedBox to display/manage the offer title
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return TextFormField(
                              clipBehavior: Clip.none,
                              controller: publishProvider.offerName,
                              textAlignVertical: TextAlignVertical.bottom,
                              onChanged: (value) {
                                publishProvider.checkFormValidity();
                              },
                              style: TextStyle(
                                  fontSize: 13
                              ),
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: AppLocalizations.of(context)!.publishHinderLabelTitle,
                                labelText: "${AppLocalizations.of(context)!.publishLabelTitle} *",
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
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      //SizedBox to display/manage the offer localisation
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              onTap: () async {
                                await publishProvider.setLocalisation();
                                publishProvider.checkFormValidity();
                              },
                              child: AbsorbPointer( // To prevent keyboard from showing up
                                child: TextFormField(
                                  readOnly: true, // Makes the TextFormField non-editable
                                  controller: publishProvider.offerLocalisation,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  onChanged: (value) {
                                    publishProvider.checkFormValidity();
                                  },
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: AppLocalizations.of(context)!.hinderTextLocalisation,
                                    prefixIcon: Icon(
                                      Icons.near_me_outlined,
                                      size: constraints.maxHeight * 0.5,
                                    ),
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
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFieldInfo(
                        textController: publishProvider.offerCityVillage,
                        label: AppLocalizations.of(context)!.publishLabelSpecLocalization,
                        parentContext: context,
                        isNumeric: false,
                      ),
                      SizedBox(height: 20),
                      // Clickable text to display the widget to manage all user information
                      Column(
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
                                        color: GlobalVariables.tertiaryColor
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: GlobalVariables.tertiaryColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (publishProvider.contactInfoActive)
                            ContactInfo(),
                          SizedBox(height: 15),
                          // If all mandatory data are valid, clickable text to display the widget to manage all the optional data become clickable (not the case per default)
                          GestureDetector(
                            onTap: () {
                              if (publishProvider.isFormValid) {
                                publishProvider.setOptionActive(!publishProvider.optionActive, homeNavigationProvider, context);
                              }
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
                                          color: GlobalVariables.tertiaryColor
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: GlobalVariables.tertiaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (publishProvider.isFormValid && publishProvider.optionActive)
                            OfferOption(publishProvider: publishProvider, homeNavigationProvider: homeNavigationProvider),
                          SizedBox(height: 15),
                          // If all mandatory data are valid, Button to call the function to publish an offer become clickable
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Opacity(
                                opacity: !publishProvider.isFormValid ? 0.3 : 1,
                                child: IgnorePointer(
                                    ignoring: !publishProvider.isFormValid,
                                    child: DefaultButton(
                                        label: context.read<MainProvider>().offerDetails != null ? AppLocalizations.of(context)!.buttonModify : AppLocalizations.of(context)!.buttonPublish,
                                        parentContext: context,
                                        function: null,
                                        futureFunction: () => context.read<MainProvider>().offerDetails != null ? publishProvider.updateOfferAsset(context, homeNavigationProvider) : publishProvider.publishOffer(context, homeNavigationProvider))
                                )
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
      },
    );
  }

}