import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/account/screen/account_screen.dart';
import 'package:Resilink/features/home/screen/home_screen.dart';
import 'package:Resilink/features/publish/screen/publish_screen.dart';
import 'package:Resilink/features/registration/screen/login_screen.dart';
import 'package:Resilink/features/news_page/screen/news_page_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/features/search/screen/search_screen.dart';

import '../../../providers/main_provider.dart';
import '../provider/home_navigation_provider.dart';

// Widget to manage available pages and their management for navigation
class HomeNavigation extends StatefulWidget {
  HomeNavigation({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeNavigationState();
  }

}

class HomeNavigationState extends State<HomeNavigation> {

  @override
  void initState() {
    super.initState();
    // Calls function to retrieve user token and data every 1 hour and 30 minutes
    context.read<MainProvider>().fetchUserDataPeriodically(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Creating the HomeNavigation provider in the tree structure
    create: (_) => HomeNavigationProvider(),
      builder: (context, child) {
        return SafeArea(
          child: Consumer2<HomeNavigationProvider, MainProvider>( // Listening to HomeNavigation and Main providers to access and update their data
            builder: (context, homeNavigationProvider, mainProvider, child) {

              if (context.read<MainProvider>().actualUser == null) {
                context.read<MainProvider>().getUserDataAndToken();
              }

              // Call the function to retrieve all assetTypes in case getUserDataAndToken is done and it has not be already called
              // Need to put it in the Consummer for it to be call when a user log out
              if (context.read<MainProvider>().actualUser != null && !homeNavigationProvider.settingAssetTypes) {
                homeNavigationProvider.setAssetTypesAndGetUser(context);
              }

              // Needed to put it un local to update the header because the parameters page is out of HomeNavigatorProvider reach
              // Need to put the list in UserProvider or put HomeNavigatorProvider as global provider if not using local variable
              List<String> _headerListValue = [
                AppLocalizations.of(context)!.home,
                AppLocalizations.of(context)!.search,
                AppLocalizations.of(context)!.publish,
                AppLocalizations.of(context)!.news,
                AppLocalizations.of(context)!.account
              ];

              /*
               * If a user is not set (connected or not (can be the public account)), return a waiting screen
               * Else return the default page with navigation
               */
              return mainProvider.actualUser != null ? Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Center(
                      child: Text(
                          _headerListValue[homeNavigationProvider.selectedIndex],
                          style: const TextStyle(
                              color: GlobalVariables.textHeaderColor
                          )
                      )
                  ),
                  backgroundColor: GlobalVariables.navigationBarColor,
                  leading: homeNavigationProvider.selectedIndex != 0 ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () {
                      /*
                       * Button to return to main screen (page 0)
                       * If hasResultSearch is true (=> search result screen page 1) and offerDetails has a value (=> offer detail screen page 1), deletes offer, asset and contract values
                       * And refresh page 1 to return to search result screen
                       * Else navigate to page 0 and if offerDetails has a value, clear it with its asset and contract.
                       */
                      if(context.read<HomeNavigationProvider>().hasResultSearch) {
                        if (context.read<MainProvider>().offerDetails != null){
                          context.read<MainProvider>().clearOfferAssetContractViewDetails();
                          context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(1);
                        } else {
                          context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(0);
                        }
                      } else {
                        context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(0);
                        if (context.read<MainProvider>().offerDetails != null){
                          context.read<MainProvider>().clearOfferAssetContractViewDetails();
                        }
                      }
                    },
                  )
                      : Container(),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined, color: Colors.black54),
                      onPressed: () {
                        //TODO to complete if notification page/features is implemented
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  elevation: 10,
                  currentIndex: homeNavigationProvider.selectedIndex,
                  onTap: (index) => {
                    /*
                     * Navigates to the page corresponding to the index obtained by clicking on a BottomNavigationBarItem
                     * And call the function to clear the offer, its asset and its contract if offerDetails has a value and navigation does not go from page 2 to page 1.
                     */
                    if (context.read<MainProvider>().offerDetails != null && (context.read<HomeNavigationProvider>().selectedIndex == 2 || index != 1)) {
                      context.read<MainProvider>().clearOfferAssetContractViewDetails(),
                    },
                    context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(index),
                  },
                  // List of navigation options in the BottomBar
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.home),
                        label: AppLocalizations.of(context)!.home
                    ),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.search),
                        label: AppLocalizations.of(context)!.search
                    ),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.add),
                        label: AppLocalizations.of(context)!.publish
                    ),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.newspaper),
                        label: AppLocalizations.of(context)!.news
                    ),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.person_2_rounded),
                        label: AppLocalizations.of(context)!.account
                    )
                  ],
                ),
                body: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: homeNavigationProvider.pageController,
                    onPageChanged: (index) {},
                    // Widgets for different browsable pages
                    children: <Widget>[
                      HomeScreen(),
                      SearchScreen(),
                      context.watch<MainProvider>().connected == true ? PublishScreen() : LoginScreen(),
                      NewsScreen(),
                      context.watch<MainProvider>().connected == true ? AccountScreen(homeNavigationProvider: homeNavigationProvider) : LoginScreen(),
                    ],
                  ),
                ),
              ) : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      }
    );
  }

}