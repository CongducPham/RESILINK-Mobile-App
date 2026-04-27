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
import 'package:resilink_mobile_application/features/publish/provider/publish_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../common/widget/textfield_info.dart';
import '../../../constants/global_variables.dart';

/// A widget that dynamically generates form fields based on specific attributes of an asset.
/// The fields can be text inputs, dropdowns, or other widgets depending on the attribute type.

class SpecificAttributesAsset extends StatelessWidget {
  SpecificAttributesAsset({super.key, required this.publishProvider});

  final PublishProvider publishProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<PublishProvider>(
      builder: (context, publishProvider, child) {
        List<Widget> widgets = [];

        // Iterates over each specific attribute and creates a corresponding widget based on its type.
        for (var attr in publishProvider.specificAttributes) {
          String name = "";
          String? hint;

          // Get localized labels.
          switch (attr.name) {
            case "Type":
              name = AppLocalizations.of(context)!.publishLabelSpecType;
              hint = AppLocalizations.of(context)!.publishHinderOfferType;
              break;
            case "Variety":
              name = AppLocalizations.of(context)!.publishLabelSpecVariety;
              hint = AppLocalizations.of(context)!.publishHinderOfferVariety;
              break;
            case "City/Village":
              name = AppLocalizations.of(context)!.publishLabelSpecLocalization;
              break;
            case "Brand":
              name = AppLocalizations.of(context)!.publishLabelSpecBrand;
              break;
            case "Model":
              name = AppLocalizations.of(context)!.publishLabelSpecModel;
              break;
            case "Year":
              name = AppLocalizations.of(context)!.publishLabelSpecYear;
              break;
            case "Usage":
              name = AppLocalizations.of(context)!.publishLabelSpecUsage;
              break;
            case "Condition":
              name = AppLocalizations.of(context)!.publishLabelSpecCondition;
              break;
            case "To":
              name = AppLocalizations.of(context)!.publishLabelSpecTo;
              break;
            case "From":
              name = AppLocalizations.of(context)!.publishLabelSpecFrom;
              break;
            default:
              break;
          }

          // Creates the appropriate widget based on the attribute's type.
          switch (attr.type) {
            case "string":
              if (attr.name != "City/Village")
                widgets.add(
                  TextFieldInfo(
                    textController: publishProvider.specificAttributeValue[attr.name],
                    label: name,
                    parentContext: context,
                    isNumeric: false,
                    testHint: hint,
                  ),
                );
              widgets.add(SizedBox(height: 10));
              break;
            case "numeric":
              widgets.add(
                TextFieldInfo(
                  textController: publishProvider.specificAttributeValue[attr.name],
                  label: name,
                  parentContext: context,
                  isNumeric: true,
                ),
              );
              widgets.add(SizedBox(height: 10));
              break;
            case "boolean":
              widgets.add(
                Container(
                  height: MediaQuery.of(context).size.height * 0.070,
                  margin: const EdgeInsets.only(left: 15),
                  child: DropdownButton<String>(
                    value: publishProvider.specificAttributeValue[attr.name].text,
                    onChanged: (String? newValue) {
                      publishProvider.setSpecificAttributes(newValue, attr.name);
                    },
                    items: const [
                      DropdownMenuItem(value: "true", child: Text("true")),
                      DropdownMenuItem(value: "false", child: Text("false")),
                    ],
                  ),
                ),
              );
              break;
            case "listAsset":
              List<String> valuesList = attr.valueList!.split(',');
              widgets.add(SizedBox(height: 10));
              widgets.add(
                // Creates a dropdown menu for attributes that have a predefined list of options.
                Container(
                  height: MediaQuery.of(context).size.height * 0.070,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownButtonFormField<String>(
                        alignment: AlignmentDirectional.topStart,
                        elevation: 0,
                        value: publishProvider.specificAttributeValue[attr.name].text,
                        onChanged: (newValue) {
                          publishProvider.setSpecificAttributes(newValue, attr.name);
                        },
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                          labelText: AppLocalizations.of(context)!.publishLabelSpecCondition,
                          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                color: GlobalVariables.unFocusBorderColor,
                                width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                color: GlobalVariables.tertiaryColor,
                                width: 2.0),
                          ),
                        ),
                        dropdownColor: GlobalVariables.navigationBarColor,
                        items: valuesList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              );
              widgets.add(SizedBox(height: 10));
              break;

            default:
              break;
          }
        }

        return Column(
          children: widgets,
        );
      },
    );
  }
}
