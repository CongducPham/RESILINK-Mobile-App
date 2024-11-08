import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/search/screen/offer_details.dart';
import 'package:Resilink/features/search/screen/result_search.dart';
import 'package:Resilink/features/search/widget/assetType_%20card.dart';
import 'package:Resilink/features/search/widget/slider_bar_custom.dart';
import 'package:Resilink/features/search/provider/search_provider.dart';
import 'package:Resilink/providers/main_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../home_navigation/provider/home_navigation_provider.dart';

/*
 * This widget is the screen for searching offers.
 * It shows search results or offer details depending on the state.
 */
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Creating the Search provider in the tree structure
    create: (_) => SearchProvider(context.read<HomeNavigationProvider>(), context.read<MainProvider>()),
      builder: (context, child) {
        return SingleChildScrollView(
          child: Consumer2<SearchProvider, MainProvider>( // Listening to Search and Main providers to access and manage their data
            builder: (context, searchProvider, userProvider, child) {
              // Case 1: Display offer details if an offer is selected from an other screen.
              if (context.read<MainProvider>().offerDetails != null) {
                return OfferDetails();
              }
              // Case 2: Display search results if the search is completed.
              else if (searchProvider.isSearchDone && context.read<HomeNavigationProvider>().hasResultSearch) {
                return ResultSearch();
              }
              // Case 3: Default search interface with input fields and filters.
              else {
                // Reset result search state.
                context.read<HomeNavigationProvider>().setHasResultSearch(false);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                    Text(
                      AppLocalizations.of(context)!.searchFirstTitle,
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.searchFirstSubText,
                    ),
                    const SizedBox(height: 15),
                    // Search input field with conditions for enabling/disabling input
                    Opacity(
                      opacity: searchProvider.selected && searchProvider.searchController.text.isEmpty ? 0.3 : 1,
                      child: IgnorePointer(
                        ignoring: searchProvider.selected && searchProvider.searchController.text.isEmpty,
                        child: Column(
                          children: [
                            // Search input field
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return TextField(
                                    textAlign: TextAlign.left,
                                    controller: searchProvider.searchController,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    focusNode: searchProvider.searchControllerFocusNode,
                                    style: const TextStyle(fontSize: 13),
                                    onChanged: (value) {
                                      // Update the selected state and filter map based on input
                                      searchProvider.setSelected(value.isNotEmpty);
                                      searchProvider.filter.setName(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.hinderTextRequest,
                                      border: OutlineInputBorder(),
                                      // Clear button when text is present
                                      suffixIcon: searchProvider.searchController.text.isNotEmpty
                                          ? IconButton(
                                        icon: Icon(Icons.clear, size: constraints.maxHeight * 0.4),
                                        onPressed: () {
                                          searchProvider.setSearchControllerAndSelected("", false);
                                        },
                                      )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Display search suggestions when input is focused and not empty
                            searchProvider.searchController.text.isNotEmpty && searchProvider.searchControllerFocusNode.hasPrimaryFocus
                                ? Container(
                              height: MediaQuery.of(context).size.height * 0.9 * searchProvider.allSugestion.length,
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.18),
                              child: ListView.separated(
                                itemCount: searchProvider.allSugestion.length,
                                separatorBuilder: (BuildContext context, int index) => Divider(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(searchProvider.allSugestion[index]),
                                    onTap: () {
                                      // Set the selected suggestion and update filter
                                      searchProvider.setSearchControllerAndSelected(searchProvider.allSugestion[index], true);
                                      searchProvider.filter.setName(searchProvider.allSugestion[index]);
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                },
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    // Text to indicate alternative search methods
                    Text(AppLocalizations.of(context)!.searchOr),
                    const SizedBox(height: 8),
                    // Horizontal list of asset types for filtering search results
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchProvider.getListAssetTypeResilink(searchProvider.assetTypeNames, context).length,
                        itemBuilder: (context, index) {
                          return Container(
                              height: MediaQuery.of(context).size.width * 0.2,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: AssetTypeCard(
                                label: searchProvider.getTradAssetType(searchProvider.assetTypeNames[index], context),
                                icon: (GlobalVariables.svgImage[searchProvider.assetTypeNames[index].toLowerCase().replaceAll(' ', '')]!),
                                parentContext: context,
                                publishProvider: null,
                              )
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Title for the localization-based search section
                    Text(
                      AppLocalizations.of(context)!.searchSecondTitle,
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextField(
                        controller: searchProvider.cityVillageController,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (value) {
                          searchProvider.setCityVillage(value);
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.publishLabelSpecLocalization,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: GlobalVariables.tertiaryColor)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Localization input field with a prefix icon for auto-localization
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return TextField(
                            readOnly: true,
                            controller: searchProvider.localisationController,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: const TextStyle(fontSize: 13),
                            onChanged: (value) {
                              searchProvider.checkFormValidity();
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.hinderTextLocalisation,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: GlobalVariables.tertiaryColor)),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.near_me_outlined, size: constraints.maxHeight * 0.5),
                                onPressed: () async {
                                  await searchProvider.setLocalisation();
                                  searchProvider.checkFormValidity();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Subtitle for the location-based search section
                    Text(AppLocalizations.of(context)!.searchSecondSubText),
                    const SizedBox(height: 20),
                    // Customized ScrollBar to determine distance in km from offer search area
                    SliderBarCustom(searchProvider: searchProvider),
                    const SizedBox(height: 8),
                    // Button to call setOfferFiltered function to get a list of filtered offer
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Opacity(
                          opacity: 1, // !searchProvider.isFormValid ? 0.3 : 1,
                          child: IgnorePointer(
                              ignoring: false, // !searchProvider.isFormValid,
                              child: DefaultButton(
                                label: AppLocalizations.of(context)!.buttonSearch,
                                parentContext: context,
                                function: null,
                                futureFunction: () => searchProvider.setOfferFiltered(context),
                              )
                          )
                      ),
                    )
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
