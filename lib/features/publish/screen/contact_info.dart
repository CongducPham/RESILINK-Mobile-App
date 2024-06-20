import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/textfield_info.dart';
import 'package:resilink_design/features/publish/provider/publish_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactInfo extends StatelessWidget {
  ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5,),
        TextFieldInfo(textController: context.read<PublishProvider>().contactName, label: AppLocalizations.of(context)!.publishLabelContactName, parentContext: context),
        TextFieldInfo(textController: context.read<PublishProvider>().contactFarm, label: AppLocalizations.of(context)!.publishLabelFarmName, parentContext: context),
        TextFieldInfo(textController: context.read<PublishProvider>().contactNumber, label: AppLocalizations.of(context)!.labelPhoneNumber, parentContext: context),
        TextFieldInfo(textController: context.read<PublishProvider>().contactEmail, label: AppLocalizations.of(context)!.labelEmail, parentContext: context),
      ],
    );
  }

}