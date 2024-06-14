import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/search/screen/offer_details.dart';
import 'package:resilink_design/features/search/screen/result_search.dart';
import 'package:resilink_design/features/search/widget/assetType_%20card.dart';
import 'package:resilink_design/features/search/widget/slider_bar_custom.dart';
import 'package:resilink_design/features/search/provider/search_provider.dart';
import 'package:resilink_design/providers/user_provider.dart';

import '../../../models/Offer.dart';
import '../../home_navigation/provider/home_navigation_provider.dart';

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
        create: (_) => SearchProvider(context.read<HomeNavigationProvider>()),
        builder: (context, child) {
          return SingleChildScrollView(

            // Utilisation de Consummer2 avec SearchProvider et UserPovider en watch (permet le setState si les variable écoutées changent),
            // utilisation du provider parent pour ne plus accéder au contenue de recherche d'offre mais directement au contenue d'une liste d'offre
            // et UserProvider pour avoir les details de l'offre selectionné s'il existe.
            // Utilisation en plus du provider HomeNavigationProvider pour savoir si on est dans le cas d'une recherche d'offre au préalable
              child: Consumer2<SearchProvider, UserProvider>(
                builder: (context, searchProvider, userProvider, child) {
                  if (context.read<UserProvider>().offerDetails != null) {
                    return OfferDetails();
                  } else if (searchProvider.isSearchDone && context.read<HomeNavigationProvider>().hasResultSearch) {
                    return ResultSearch();
                    } else {
                    context.read<HomeNavigationProvider>().setHasResultSearch(false);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What are you looking for ?",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            "There are 2 ways to search, use one of them."
                        ),
                        const SizedBox(height: 15),
                        Opacity(
                          opacity: searchProvider.selected && searchProvider.searchController.text.isEmpty ? 0.3: 1,
                          child: IgnorePointer(
                            ignoring: searchProvider.selected && searchProvider.searchController.text.isEmpty,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return TextField(
                                        controller: searchProvider.searchController,
                                        textAlignVertical: TextAlignVertical.center,
                                        focusNode: searchProvider.searchControllerFocusNode,
                                        style: const TextStyle(
                                            fontSize: 13
                                        ),
                                        onChanged: (value) {
                                          searchProvider.setSelected( value.isNotEmpty ? true : false);
                                          searchProvider.filter.setName(value);
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Write your request",
                                          border: OutlineInputBorder(),
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
                                searchProvider.searchController.text.isNotEmpty && searchProvider.searchControllerFocusNode.hasPrimaryFocus ?
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.9 * searchProvider.allSugestion.length,
                                  constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.18
                                  ),
                                  child: ListView.separated(
                                    itemCount: searchProvider.allSugestion.length,
                                    separatorBuilder: (BuildContext context, int index) => Divider(),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(searchProvider.allSugestion[index]),
                                        onTap: () {
                                          searchProvider.setSearchControllerAndSelected(searchProvider.allSugestion[index], true);
                                          searchProvider.filter.setName(searchProvider.allSugestion[index]);
                                          FocusScope.of(context).unfocus();
                                        },
                                      );
                                    },
                                  ),
                                ) : Container(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("or"),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: context.read<SearchProvider>().assetTypeNames.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: MediaQuery.of(context).size.width * 0.2,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: AssetTypeCard(label: context.read<SearchProvider>().assetTypeNames[index], icon: Icons.add_alarm_outlined, parentContext: context, publishProvider: null,)
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Where do you search ?",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return TextField(
                                controller: searchProvider.localisationController,
                                textAlignVertical: TextAlignVertical.bottom,
                                style: const TextStyle(
                                    fontSize: 13
                                ),
                                onChanged: (value) {
                                  searchProvider.checkFormValidity();
                                },
                                decoration: InputDecoration(
                                  hintText: "Type a place or use the geolocalisation",
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: GlobalVariables.tersiaryColor)
                                  ),
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.near_me_outlined, size: constraints.maxHeight * 0.5),
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text("Within a radius of"),
                        const SizedBox(height: 20),
                        SliderBarCustom(currentValue: 0),
                        const SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Opacity(
                              opacity: !searchProvider.isFormValid ? 0.3: 1,
                              child: IgnorePointer(
                                  ignoring: !searchProvider.isFormValid,
                                  child: DefaultButton(label: "Search", parentContext: context, function: () {
                                    context.read<HomeNavigationProvider>().setHasResultSearch(true);
                                    searchProvider.setSearchDone(true);
                                    }, futureFunction: null)
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
