/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
import 'package:resilink_mobile_application/features/news_page/screen/news_adding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/account/screen/account_screen.dart';
import 'package:resilink_mobile_application/features/home/screen/home_screen.dart';
import 'package:resilink_mobile_application/features/publish/screen/publish_screen.dart';
import 'package:resilink_mobile_application/features/registration/screen/login_screen.dart';
import 'package:resilink_mobile_application/features/news_page/screen/news_page_screen.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/search/screen/search_screen.dart';

import '../../../providers/main_provider.dart';
import '../provider/home_navigation_provider.dart';

// Widget to manage available pages and their navigation
class HomeNavigation extends StatefulWidget {
  HomeNavigation({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeNavigationState();
  }
}

class HomeNavigationState extends State<HomeNavigation> {

  // Stable keys created once, never recreated on rebuild.
  // Prevents PublishScreen and LoginScreen from being destroyed and recreated
  // when a parent rebuild occurs (e.g. after returning from camera/gallery).
  final Key _publishKey = GlobalKey();
  final Key _loginKeyPublish = GlobalKey();
  final Key _loginKeyAccount = GlobalKey();

  bool _periodicFetchStarted = false;

  @override
  void initState() {
    super.initState();
    // Calls function to retrieve user token and data every 1 hour and 30 minutes
    if (!_periodicFetchStarted) {
      _periodicFetchStarted = true;
      context.read<MainProvider>().fetchUserDataPeriodically(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Creating the HomeNavigation provider in the tree structure
      create: (_) => HomeNavigationProvider(),
      builder: (context, child) {
        return SafeArea(
          child: Consumer2<HomeNavigationProvider, MainProvider>(
            // Listening to HomeNavigation and Main providers to access and update their data
            builder: (context, homeNavigationProvider, mainProvider, child) {

              if (context.read<MainProvider>().actualUser == null) {
                context.read<MainProvider>().getUserDataAndToken();
              }

              // Call the function to retrieve all assetTypes once getUserDataAndToken
              // is done and it has not already been called.
              // Needs to be inside the Consumer to be called when a user logs out.
              if (context.read<MainProvider>().actualUser != null && !homeNavigationProvider.settingAssetTypes) {
                homeNavigationProvider.setAssetTypesAndGetUser(context);
              }

              // Stored locally to update the header because the parameters page
              // is out of HomeNavigationProvider's reach.
              // Move the list to UserProvider or make HomeNavigationProvider global
              // if a local variable is no longer suitable.
              List<String> headerListValue = [
                AppLocalizations.of(context)!.home,
                AppLocalizations.of(context)!.search,
                AppLocalizations.of(context)!.publish,
                AppLocalizations.of(context)!.news,
                AppLocalizations.of(context)!.account,
              ];

              // If a user is not set (connected or not), return a loading screen.
              // Otherwise return the default page with navigation.
              return mainProvider.actualUser != null
                  ? Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Material(
                    color: GlobalVariables.headerBackgroundColor,
                    elevation: 4,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        title: Text(
                          headerListValue[homeNavigationProvider.selectedIndex],
                          style: const TextStyle(color: GlobalVariables.textHeaderColor),
                        ),
                        leading: homeNavigationProvider.selectedIndex != 0
                            ? IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black54),
                          onPressed: () {
                            if (context.read<MainProvider>().offerDetails != null) {
                              final cameFromHome = context.read<MainProvider>().offerBlockedFromHome;
                              context.read<MainProvider>().clearOfferAssetContractViewDetails();
                              if (cameFromHome) {
                                homeNavigationProvider.setIndexAndUpdateHeader(0); // Back to HomeScreen
                              } else {
                                homeNavigationProvider.setIndexAndUpdateHeader(1); // Back to SearchScreen
                              }
                            } else if (context.read<HomeNavigationProvider>().hasResultSearch) {
                              homeNavigationProvider.setIndexAndUpdateHeader(0);
                              homeNavigationProvider.setHasResultSearch(false);
                            } else {
                              homeNavigationProvider.setIndexAndUpdateHeader(0);
                            }
                          },
                        )
                            : IconButton(
                          icon: const Icon(Icons.refresh_outlined, color: Colors.black54),
                          onPressed: () {
                            homeNavigationProvider.setHomeKey();
                          },
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black54),
                            onPressed: () {
                              // TODO: notification page
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Material(
                  elevation: 10,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: GlobalVariables.navigationBarColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: BottomNavigationBar(
                        backgroundColor: GlobalVariables.navigationBarColor,
                        type: BottomNavigationBarType.fixed,
                        elevation: 0,
                        selectedItemColor: GlobalVariables.focusNavigationBarColor,
                        unselectedItemColor: GlobalVariables.unFocusNavigationBarColor,
                        currentIndex: homeNavigationProvider.selectedIndex,
                        onTap: (index) {
                          if (context.read<MainProvider>().offerDetails != null &&
                              (homeNavigationProvider.selectedIndex == 2 || index != 1)) {
                            context.read<MainProvider>().clearOfferAssetContractViewDetails();
                          }
                          homeNavigationProvider.setHasResultSearch(false);
                          homeNavigationProvider.setIndexAndUpdateHeader(index);
                        },
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.home),
                            label: AppLocalizations.of(context)!.home,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.search),
                            label: AppLocalizations.of(context)!.search,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.add),
                            label: AppLocalizations.of(context)!.publish,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.newspaper),
                            label: AppLocalizations.of(context)!.news,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.person_2_rounded),
                            label: AppLocalizations.of(context)!.account,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: homeNavigationProvider.pageController,
                    onPageChanged: (index) {},
                    // Widgets for each navigable page
                    children: <Widget>[
                      HomeScreen(key: homeNavigationProvider.homeKey),
                      SearchScreen(),
                      context.watch<MainProvider>().connected == true
                          ? PublishScreen(key: _publishKey)
                          : LoginScreen(key: _loginKeyPublish),
                      NewsScreen(),
                      context.watch<MainProvider>().connected == true
                          ? AccountScreen(homeNavigationProvider: homeNavigationProvider)
                          : LoginScreen(key: _loginKeyAccount),
                    ],
                  ),
                ),
              )
                  : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}