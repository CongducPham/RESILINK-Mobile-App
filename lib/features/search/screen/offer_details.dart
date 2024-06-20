import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfferDetails extends StatelessWidget {
  const OfferDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
          color: GlobalVariables.navigationBarColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        constraints: const BoxConstraints(
          minHeight: 350
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.15,
                      width: constraints.maxWidth,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: constraints.maxWidth * 0.8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      context.read<UserProvider>().assetDetails!.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                      )
                                    )
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                        context.read<UserProvider>().offerDetails!.price != 0 ? context.read<UserProvider>().offerDetails!.price.toString() : AppLocalizations.of(context)!.offerDetailsNoPrice,
                                        style: TextStyle(
                                            fontSize: 12
                                        )
                                    )
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {  },
                              icon: Icon(Icons.bookmark_add_outlined),
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: constraints.maxHeight * 0.40,
                      color: GlobalVariables.navigationBarColor,
                      child: Center(
                        child: Image(
                          image: AssetImage(GlobalVariables.assetTypeImages['noimage']!),
                        ),
                      )
                    ),
                    Container(
                      height: constraints.maxHeight * 0.35,
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.offerDetailsPublisher} ${context.read<UserProvider>().offerDetails!.offerer}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                              ),
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.offerDetailsPeriod} ${context.read<UserProvider>().offerDetails!.beginTimeSlot} - ${context.read<UserProvider>().offerDetails!.validityLimit}",
                              style: TextStyle(
                                  fontSize: 12
                              ),
                            textDirection: TextDirection.ltr,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                          Text(
                              context.read<UserProvider>().assetDetails!.description,
                              style: TextStyle(
                                  fontSize: 12
                              )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DefaultButton(label: AppLocalizations.of(context)!.buttonContact, parentContext: context, function: null, futureFunction: null),
                            SizedBox(width: 8),
                            DefaultButton(label: AppLocalizations.of(context)!.buttonPurchase, parentContext: context, function: null, futureFunction: null)
                          ],
                        )
                    )
                  ],
                );
              }
          ),
        ),
      ),
    );
  }

}