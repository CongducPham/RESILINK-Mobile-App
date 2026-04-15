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