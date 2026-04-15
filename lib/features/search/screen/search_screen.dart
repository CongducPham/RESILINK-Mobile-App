import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/search/screen/offer_details.dart';
import 'package:resilink_mobile_application/features/search/screen/result_search.dart';
import 'package:resilink_mobile_application/features/search/widget/assetType_%20card.dart';
import 'package:resilink_mobile_application/features/search/widget/slider_bar_custom.dart';
import 'package:resilink_mobile_application/features/search/provider/search_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

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
      create: (_) => SearchProvider(
          context.read<HomeNavigationProvider>(), context.read<MainProvider>(), context),
      builder: (context, child) {
        return Consumer2<SearchProvider, MainProvider>(
          // Listening to Search and Main providers to access and manage their data
          builder: (context, searchProvider, userProvider, child) {
            // Case 1: Display offer details if an offer is selected from another screen.
            if (context.read<MainProvider>().offerDetails != null) {
              return SingleChildScrollView(child: OfferDetails());
            }
            // Case 2: Display search results if the search is completed.
            else if (searchProvider.isSearchDone &&
                context.read<HomeNavigationProvider>().hasResultSearch) {
              return ResultSearch();
            }
            // Case 3: Default search interface with input fields and filters.
            else {
              // Reset result search state.
              context.read<HomeNavigationProvider>().setHasResultSearch(false);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                    // First section title — headlineMedium for a prominent page heading
                    Text(
                      AppLocalizations.of(context)!.searchFirstTitle,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // First section subtitle — bodyLarge for readable supporting text
                    Text(
                      AppLocalizations.of(context)!.searchFirstSubText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 15),
                    // Search input field with conditions for enabling/disabling input
                    Opacity(
                      opacity: searchProvider.selected &&
                          searchProvider.searchController.text.isEmpty
                          ? 0.3
                          : 1,
                      child: IgnorePointer(
                        ignoring: searchProvider.selected &&
                            searchProvider.searchController.text.isEmpty,
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
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    onChanged: (value) {
                                      // Update selected state and filter map based on input
                                      searchProvider.setSelected(value.isNotEmpty);
                                      searchProvider.filter.setName(value.trim());
                                      if (value.length > 30) {
                                        searchProvider.searchController.text =
                                            value.substring(0, 30);
                                        searchProvider.searchController.selection =
                                            TextSelection.fromPosition(
                                              // Preserve cursor position after truncation
                                              TextPosition(
                                                  offset: searchProvider
                                                      .searchController.text.length),
                                            );
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.hinderTextRequest,
                                      border: const OutlineInputBorder(),
                                      // Clear button shown when text is present
                                      suffixIcon:
                                      searchProvider.searchController.text.isNotEmpty
                                          ? IconButton(
                                        icon: Icon(Icons.clear,
                                            size: constraints.maxHeight * 0.4),
                                        onPressed: () {
                                          searchProvider.filter.clearName();
                                          searchProvider
                                              .setSearchControllerAndSelected("", false);
                                        },
                                      )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Display search suggestions when input is focused and not empty
                            searchProvider.searchController.text.isNotEmpty &&
                                searchProvider.searchControllerFocusNode.hasPrimaryFocus
                                ? Container(
                              height: MediaQuery.of(context).size.height *
                                  0.9 *
                                  searchProvider.allSugestion.length,
                              constraints: BoxConstraints(
                                  maxHeight:
                                  MediaQuery.of(context).size.height * 0.18),
                              child: ListView.separated(
                                itemCount: searchProvider.allSugestion.length,
                                separatorBuilder: (BuildContext context, int index) =>
                                const Divider(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(searchProvider.allSugestion[index]),
                                    onTap: () {
                                      // Set the selected suggestion and update filter
                                      searchProvider.setSearchControllerAndSelected(
                                          searchProvider.allSugestion[index], true);
                                      searchProvider.filter.setName(
                                          searchProvider.allSugestion[index]);
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
                    // Label indicating an alternative search method
                    Text(AppLocalizations.of(context)!.searchOr),
                    const SizedBox(height: 8),
                    // Horizontal list of asset types for filtering search results
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchProvider
                            .getListAssetTypeResilink(searchProvider.assetTypeNames, context)
                            .length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: AssetTypeCard(
                              label: searchProvider.assetTypeNames[index],
                              icon: (GlobalVariables.svgImage[searchProvider.assetTypeNames[index]
                                  .toLowerCase()
                                  .replaceAll(' ', '')]!),
                              parentContext: context,
                              publishProvider: null,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Second section title — headlineMedium for consistency with first title
                    Text(
                      AppLocalizations.of(context)!.searchSecondTitle,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextField(
                        clipBehavior: Clip.none,
                        controller: searchProvider.cityVillageController,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          searchProvider.setCityVillage(value);
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.publishLabelSpecLocalization,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: GlobalVariables.tertiaryColor)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.searchOr),
                    const SizedBox(height: 8),
                    // Localization input field with prefix icon for GPS auto-localization
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return TextField(
                            readOnly: true,
                            controller: searchProvider.localisationController,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: Theme.of(context).textTheme.bodyMedium,
                            onChanged: (value) {
                              searchProvider.checkFormValidity();
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.searchHinderTextLocalisation,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: GlobalVariables.tertiaryColor)),
                              suffixIcon:
                              searchProvider.localisationController.text.isNotEmpty
                                  ? IconButton(
                                icon: Icon(Icons.clear,
                                    size: constraints.maxHeight * 0.4),
                                onPressed: () {
                                  searchProvider.setLocalisation("");
                                },
                              )
                                  : null,
                              prefixIcon: IconButton(
                                icon: Icon(Icons.near_me_outlined,
                                    size: constraints.maxHeight * 0.5),
                                onPressed: () async {
                                  await searchProvider.setLocalisationByGPS();
                                  searchProvider.checkFormValidity();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          searchProvider.setLocalisation(
                              context.read<MainProvider>().actualUser!.gps);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.publishTextButtonLocalization,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextField(
                        clipBehavior: Clip.none,
                        controller: searchProvider.countryController,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.chooseCountry,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: GlobalVariables.tertiaryColor)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Subtitle for the distance-based search section — bodyLarge
                    Text(
                      AppLocalizations.of(context)!.searchSecondSubText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    // Custom slider to set the search radius in km
                    SliderBarCustom(searchProvider: searchProvider),
                    const SizedBox(height: 8),
                    // Button to trigger the filtered offer search
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Opacity(
                        opacity: 1,
                        child: IgnorePointer(
                          ignoring: false,
                          child: DefaultButton(
                            label: AppLocalizations.of(context)!.buttonSearch,
                            parentContext: context,
                            function: null,
                            futureFunction: () => searchProvider.setOfferFiltered(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}