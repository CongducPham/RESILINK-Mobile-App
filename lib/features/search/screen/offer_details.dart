import 'package:Resilink/common/widget/default_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/service/Launch_in_external_app.dart';
import '../provider/search_provider.dart';
import '../provider/update_contract.dart';

// The OfferDetails widget displays offer details, enables contact and purchase actions, and allows contract management.
class OfferDetails extends StatelessWidget {
  const OfferDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer2<SearchProvider, HomeNavigationProvider>( // Listening to Search, HomeNavigation provider to access their data and manage them
        builder: (context, searchProvider, homeNavigationProvider, child) {
          return Column(
            children: [
              // Container displaying offer details
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: GlobalVariables.unFocusBorderColor),
                  color: GlobalVariables.navigationBarColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section displaying asset name, price, and quantity
                      Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                          minHeight: 60
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width * 0.6, // Fixed width for the text section
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      context.read<MainProvider>().assetDetails!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.offerDetailsPrice,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          context.read<MainProvider>().offerDetails!.price != 0
                                              ? context.read<MainProvider>().offerDetails!.price.toString()
                                              : AppLocalizations.of(context)!.offerDetailsNoPrice,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.offerDetailsQuantity,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          context.read<MainProvider>().assetDetails!.totalQuantity != 0
                                              ? context.read<MainProvider>().assetDetails!.totalQuantity.toString()
                                              : AppLocalizations.of(context)!.offerDetailsMaterial,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1, // Fixed width for the bookmark icon
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.bookmark_add_outlined),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1, // Fixed width for the delete icon
                              child: IconButton(
                                onPressed: () {
                                  DefaultPopUp.show(
                                    context,
                                        () => searchProvider.addBlockedOffer(
                                        context,
                                        context.read<MainProvider>().offerDetails!,
                                        homeNavigationProvider),
                                    null,
                                  );
                                },
                                icon: const Icon(Icons.delete_forever, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Section displaying the asset image
                      Container(
                        height: MediaQuery.of(context).size.height * 0.21,
                        color: GlobalVariables.navigationBarColor,
                        child: Center(
                          child: context.read<MainProvider>().assetDetails!.images!.isEmpty
                              ? Image(
                            image: AssetImage(
                              GlobalVariables.assetTypeImages[
                              context.read<MainProvider>().assetDetails?.assetType.toLowerCase().replaceAll(RegExp(r'\d+'), '') ??
                                  'noimage']!,
                            ),
                          )
                              : Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(4),
                                scrollDirection: Axis.horizontal,
                                itemCount: context.read<MainProvider>().assetDetails!.images!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: context.read<MainProvider>().assetDetails!.images![index].toString().contains("https://")
                                        ? Image.network(
                                      context.read<MainProvider>().assetDetails!.images![index],
                                      fit: BoxFit.fill,
                                    )
                                        : Image.memory(
                                      fit: BoxFit.fill,
                                      context.read<MainProvider>().convertBase64ToImg(
                                        context.read<MainProvider>().assetDetails!.images![index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Section displaying additional offer details
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.offerDetailsPublisher} ${context.read<MainProvider>().offerDetails!.offerer}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.offerDetailsPeriod,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  context.read<MainProvider>().offerDetails!.beginTimeSlot,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.offerDetailsPeriodEnd,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  context.read<MainProvider>().offerDetails!.validityLimit,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            if (context.read<MainProvider>().assetDetails!.specificAttributes! != null && context.read<MainProvider>().assetDetails!.specificAttributes!.isNotEmpty)
                              for (var attribute in context.read<MainProvider>().assetDetails!.specificAttributes!)
                                if (attribute.value.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    '${attribute.attributeName}: ${attribute.value}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            SizedBox(height: 20),
                            // Scrollable text section for asset description
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height * 0.1
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 1), // Bordure légère
                                borderRadius: BorderRadius.circular(8.0), // Arrondir les coins de la bordure
                              ),
                              padding: const EdgeInsets.all(8.0), // Ajoute un padding pour aérer le contenu
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Description: ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: context.read<MainProvider>().assetDetails!.description.isEmpty ? "no details given by seller" : context.read<MainProvider>().assetDetails!.description,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Buttons for contacting and purchasing
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DefaultButton(
                              label: AppLocalizations.of(context)!.buttonContact,
                              parentContext: context,
                              function: () => context.read<MainProvider>().offerDetails!.ownerPhoneNumber != ""
                                  ? launchInBrowser(Uri.parse("https://wa.me/${context.read<MainProvider>().offerDetails!.ownerPhoneNumber}"))
                                  : null,
                              futureFunction: null,
                            ),
                            const SizedBox(width: 8),
                            Opacity(
                              opacity: context.read<MainProvider>().forPurchase ? 1 : 0.3,
                              child: DefaultButton(
                                label: AppLocalizations.of(context)!.buttonPurchase,
                                parentContext: context,
                                function: null,
                                futureFunction: () => searchProvider.buyingServices(
                                    context,
                                    context.read<MainProvider>().assetDetails!,
                                    context.read<MainProvider>().offerDetails!,
                                    homeNavigationProvider),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Conditional display of contract management options if there is an actual contract
              if (context.read<MainProvider>().actualContract != null)
                ChangeNotifierProvider(
                    // Creating the UpdateContract provider in the tree structure
                    create: (_) => UpdateContractProvider(),
                    builder: (context, child) {
                      return Consumer<UpdateContractProvider>( // Listening to UpdateContract provider to access their data and manage
                          builder: (context, updateContractProvider, child) {

                            // Initialize data based on the current contract if it has not be already done
                            if (updateContractProvider.deliveryState.isEmpty) {
                              updateContractProvider.setInitialValue(
                                  context.read<MainProvider>().actualContract!,
                                  homeNavigationProvider.allAssetType[context.read<MainProvider>().assetDetails!.assetType]!.nature,
                                  context
                              );
                            }

                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                  const SizedBox(height: 15),
                                  Center(
                                      child: Text(
                                          AppLocalizations.of(context)!.contractChangeStateText,
                                          style: const TextStyle(fontSize: 18)
                                      )
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                      AppLocalizations.of(context)!.contractActualStateText,
                                      style: TextStyle(fontSize: 16)
                                  ),
                                  const SizedBox(height:10),
                                  Center(
                                      child: Text(
                                          context.read<MainProvider>().actualContract!.state,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                      )
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                      AppLocalizations.of(context)!.contractNewStateText,
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height:10),
                                  // Button to call method to update the contract
                                  Center(
                                    child: DropdownButton(
                                      value: updateContractProvider.deliveryValue,
                                      items: updateContractProvider.deliveryState.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(fontSize: 14),),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        updateContractProvider.setDeliveryValue(value!);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      DefaultButton(label: AppLocalizations.of(context)!.buttonDelete, parentContext: context, function: null, futureFunction: () => updateContractProvider.deleteContract(context, context.read<MainProvider>().actualContract!, homeNavigationProvider)),
                                      const SizedBox(width: 10),
                                      DefaultButton(label: AppLocalizations.of(context)!.buttonModify, parentContext: context, function: null, futureFunction: () => updateContractProvider.updateContract(context, context.read<MainProvider>().actualContract!, homeNavigationProvider.allAssetType[context.read<MainProvider>().assetDetails!.assetType]!.nature, homeNavigationProvider)),
                                    ],
                                  ),
                                  // Stepper widget showing the current status of the contract
                                  Stepper(
                                      controller: ScrollController(keepScrollOffset: false),
                                      currentStep: updateContractProvider.currentStep,
                                      controlsBuilder: (context, details) {
                                        return const SizedBox();
                                      },
                                      steps: [
                                        Step(
                                            title: Text(AppLocalizations.of(context)!.contractStateProceeding,),
                                            content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis,),
                                            isActive: updateContractProvider.currentStep >= 0,
                                            state: updateContractProvider.currentStep >= 0 ? StepState.complete : StepState.disabled
                                        ),
                                        Step(
                                            title: Text(AppLocalizations.of(context)!.contractActualStateText,),
                                            content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis,),
                                            isActive: updateContractProvider.currentStep >= 1,
                                            state: updateContractProvider.currentStep >= 1 ? StepState.complete : StepState.disabled
                                        ),
                                        Step(
                                            title: Text(AppLocalizations.of(context)!.contractStateReceived),
                                            content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis,),
                                            isActive: updateContractProvider.currentStep >= 2,
                                            state: updateContractProvider.currentStep >= 2 ? StepState.complete : StepState.disabled
                                        ),
                                        Step(
                                            title: Text(AppLocalizations.of(context)!.contractStateDelivered,),
                                            content: Text(updateContractProvider.stepperText, overflow: TextOverflow.ellipsis,),
                                            isActive: updateContractProvider.currentStep >= 3,
                                            state: updateContractProvider.currentStep >= 3 ? StepState.complete : StepState.disabled
                                        ),
                                      ]
                                  )
                                ]
                            );
                          }
                      );
                    }
                ),
            ],
          );
        },
      ),
    );
  }

}