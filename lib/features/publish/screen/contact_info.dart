import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/textfield_info.dart';
import 'package:resilink_design/features/publish/provider/publish_provider.dart';

class ContactInfo extends StatelessWidget {
  ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5,),
        TextFieldInfo(textController: context.read<PublishProvider>().contactName, label: "Contact name", parentContext: context),
        TextFieldInfo(textController: context.read<PublishProvider>().contactFarm, label: "Farm name", parentContext: context),
        TextFieldInfo(textController: context.read<PublishProvider>().contactNumber, label: "Phone number", parentContext: context),
        TextFieldInfo(textController: context.read<PublishProvider>().contactEmail, label: "Email", parentContext: context),

      ],
    );
  }

}