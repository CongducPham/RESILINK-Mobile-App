import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/textfield_info.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_mobile_application/features/publish/provider/publish_provider.dart';
import 'package:resilink_mobile_application/features/publish/screen/offerImages.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';

import '../widget/specific_attributes_asset.dart';

// Widget to display all optional data
class OfferOption extends StatefulWidget {
  OfferOption({super.key, required this.publishProvider, required this.homeNavigationProvider});

  PublishProvider publishProvider;
  HomeNavigationProvider homeNavigationProvider;

  @override
  State<StatefulWidget> createState() {
    return OfferOptionState();
  }
}

class OfferOptionState extends State<OfferOption> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.publishLabelDuration,
          style: Theme.of(context).textTheme.bodyLarge
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Flexible(
              // TextField to display/update offer duration
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextField(
                  buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
                  controller: widget.publishProvider.offerDuration,
                  maxLines: 1,
                  maxLength: 3,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(overflow: TextOverflow.ellipsis),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: GlobalVariables.unFocusBorderColor,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: GlobalVariables.unFocusBorderColor,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )
            ),
            SizedBox(width: 15),
            // Container to display/update offer duration range (day/week/month)
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.16,
              constraints: const BoxConstraints(
                minWidth: 60
              ),
              padding: EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                border: Border.all(color: GlobalVariables.unFocusBorderColor, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  alignment: AlignmentDirectional.topCenter,
                  iconSize: 18,
                  value: widget.publishProvider.offerDurationRange,
                  onChanged: (String? newValue) {
                    widget.publishProvider.setOfferDurationRange(newValue!);
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'week',
                      child: Text(AppLocalizations.of(context)!.secondTypeDuration, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: 'day',
                      child: Text(AppLocalizations.of(context)!.firstTypeDuration, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: 'month',
                      child: Text(AppLocalizations.of(context)!.thirdTypeDuration, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        // If specific dates are required, option to add date fields
        if (context.read<MainProvider>().offerDetails != null)
          Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.publishLabelAddDuration),
                  Checkbox(value: widget.publishProvider.addDuration, onChanged: (bool? newValue) {
                    widget.publishProvider.setAddDuration(newValue!);
                  }),
                ],
              ),
            ],
          ),
        SizedBox(height: 10),
        TextFieldInfo(textController: widget.publishProvider.offerPrice, label: AppLocalizations.of(context)!.publishLabelPrice, parentContext: context, isNumeric: true,),
        SizedBox(height: 10),
        SpecificAttributesAsset(publishProvider: widget.publishProvider),
        SizedBox(height: 10),
        // Container to display/update offer description
        Container(
          padding: EdgeInsets.all(5),
          constraints: BoxConstraints(
            minHeight: 50,
          ),
          color: GlobalVariables.navigationBarColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.publishLabelDetails,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: widget.publishProvider.offerDescription,
                focusNode: widget.publishProvider.focusNodeDescription,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.publishHinderDetails,
                  border: InputBorder.none,
                ),
                onChanged: (String value) {},
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        Text(
          AppLocalizations.of(context)!.publishLabelImages,
          style: Theme.of(context).textTheme.bodyLarge
        ),
        SizedBox(height: 15),
        // Widget to display/update offer images
        OfferImages(publishProvider: widget.publishProvider),
      ],
    );
  }

}