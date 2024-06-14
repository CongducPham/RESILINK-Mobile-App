import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/textfield_info.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:resilink_design/features/publish/provider/publish_provider.dart';
import 'package:resilink_design/features/publish/screen/offerImages.dart';

class OfferOption extends StatefulWidget {
  OfferOption({super.key, required this.publishProvider});

  PublishProvider publishProvider;

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
          "Duration of your good",
          style: TextStyle(
              fontSize: 15
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Flexible(
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
                  style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis,),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
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
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.15,
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
                  items: const [
                    DropdownMenuItem(
                      value: 'week',
                      child: Text('week', style: TextStyle(fontSize: 12)),
                    ),
                    DropdownMenuItem(
                      value: 'day',
                      child: Text('day', style: TextStyle(fontSize: 12)),
                    ),
                    DropdownMenuItem(
                      value: 'month',
                      child: Text('month', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        TextFieldInfo(textController: widget.publishProvider.offerPrice, label: "Your sale or rental price", parentContext: context),
        SizedBox(height: 10),
        if (context.read<HomeNavigationProvider>().allAssetType[widget.publishProvider.assetType]!.nature == "immaterial" ||
            context.read<HomeNavigationProvider>().allAssetType[widget.publishProvider.assetType]!.nature == "immaterialNotQuantified")
          Column(
            children: [
              TextFieldInfo(textController: widget.publishProvider.offerLocalisation , label: "The quantity of your goods", parentContext: context),
              SizedBox(height: 20),
            ],
          ),
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
                "Details",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: widget.publishProvider.offerDescription,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14
                ),
                decoration: const InputDecoration(
                  hintText: 'Give more details of your offer here',
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
          "Add pictures",
          style: TextStyle(
              fontSize: 15
          ),
        ),
        SizedBox(height: 15),
        OfferImages(),
      ],
    );
  }

}