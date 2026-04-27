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
import 'package:resilink_mobile_application/common/widget/textfield_info.dart';
import 'package:resilink_mobile_application/features/publish/provider/publish_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

// Widget to display user information when creating/updating an offer
class ContactInfo extends StatelessWidget {
  ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5,),
        TextFieldInfo(textController: context.read<PublishProvider>().contactName, label: AppLocalizations.of(context)!.publishLabelContactName, parentContext: context, isNumeric: false,),
        TextFieldInfo(textController: context.read<PublishProvider>().contactFarm, label: AppLocalizations.of(context)!.publishLabelFarmName, parentContext: context, isNumeric: false,),
        TextFieldInfo(textController: context.read<PublishProvider>().contactNumber, label: AppLocalizations.of(context)!.labelPhoneNumber, parentContext: context, isNumeric: true,),
        TextFieldInfo(textController: context.read<PublishProvider>().contactEmail, label: AppLocalizations.of(context)!.labelEmail, parentContext: context, isNumeric: false,),
      ],
    );
  }

}