import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/account/screen/account_screen.dart';
import 'package:resilink_design/features/home/screen/home_screen.dart';
import 'package:resilink_design/features/publish/screen/publish_screen.dart';
import 'package:resilink_design/features/registration/screen/login_screen.dart';
import 'package:resilink_design/features/news_page/screen/news_page_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:resilink_design/features/search/screen/search_screen.dart';

import '../../../providers/user_provider.dart';
import '../provider/home_navigation_provider.dart';

class HomeNavigation extends StatefulWidget {
  HomeNavigation({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeNavigationState();
  }

}

class HomeNavigationState extends State<HomeNavigation> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    // initialize pages
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNavigationProvider(),
      builder: (context, child) {
        return SafeArea(
          child: Consumer2<UserProvider, HomeNavigationProvider>(
            builder: (context, userProvider, homeNavigationProvider, child) {

              // Needed to put it un local to update the header because the parameters page is out of HomeNavigatorProvider reach
              // Need to put the list in UserProvider or put HomeNavigatorProvider as global provider if not using local variable
              List<String> _headerListValue = [
                AppLocalizations.of(context)!.home,
                AppLocalizations.of(context)!.search,
                AppLocalizations.of(context)!.publish,
                AppLocalizations.of(context)!.news,
                AppLocalizations.of(context)!.account
              ];

              return Scaffold(
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
                      if(context.read<HomeNavigationProvider>().hasResultSearch) {
                        if (context.read<UserProvider>().offerDetails != null){
                          context.read<UserProvider>().clearOfferAndAssetViewDetails();
                          context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(1);
                        }
                      } else {
                        context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(0);
                        if (context.read<UserProvider>().offerDetails != null){
                          context.read<UserProvider>().clearOfferAndAssetViewDetails();
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
                    context.read<HomeNavigationProvider>().setIndexAndUpdateHeader(index),
                    if (context.read<UserProvider>().offerDetails != null && index != 1){
                      context.read<UserProvider>().clearOfferAndAssetViewDetails()
                    },
                  },
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
                    children: <Widget>[
                      HomeScreen(),
                      SearchScreen(),
                      context.watch<UserProvider>().connected == true ? PublishScreen() : LoginScreen(),
                      NewsScreen(),
                      context.watch<UserProvider>().connected == true ? AccountScreen(homeNavigationProvider: homeNavigationProvider) : LoginScreen(),
                    ],
                  ),//_buildAnimatedSwitcher()
                ),
              );
            },
          ),
        );
      }
    );
  }

}