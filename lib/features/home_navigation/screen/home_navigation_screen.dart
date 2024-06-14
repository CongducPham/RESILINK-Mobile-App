import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/account/screen/account_screen.dart';
import 'package:resilink_design/features/home/screen/home_screen.dart';
import 'package:resilink_design/features/publish/screen/publish_screen.dart';
import 'package:resilink_design/features/registration/screen/login_screen.dart';
import 'package:resilink_design/features/news_page/screen/news_page_screen.dart';
import 'package:resilink_design/features/search/screen/offer_details.dart';
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
  List<Widget> _pages = [];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages.clear();

    // initialize pages after iniState ends
    _pages.add(HomeScreen());
    _pages.add(SearchScreen());
    _pages.add(context.watch<UserProvider>().connected == true ? PublishScreen() : LoginScreen());
    _pages.add(NewsScreen());
    _pages.add(context.watch<UserProvider>().connected == true ? AccountScreen() : LoginScreen());
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
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                      context.watch<HomeNavigationProvider>().headerText,
                      style: const TextStyle(
                          color: GlobalVariables.textHeaderColor
                      )
                  )
              ),
              backgroundColor: GlobalVariables.navigationBarColor,
              leading: context.watch<HomeNavigationProvider>().selectedIndex != 0 ? IconButton(
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
              currentIndex: context.watch<HomeNavigationProvider>().selectedIndex,
              onTap: (index) => {
                context.read<HomeNavigationProvider>().setActualPageOnItemTapped(index),
                if (context.read<UserProvider>().offerDetails != null && index != 1){
                  context.read<UserProvider>().clearOfferAndAssetViewDetails()
                },
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: "Search"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: "Publish"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.newspaper),
                    label: "News"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_rounded),
                    label: "Account"
                )
              ],
            ),
            body: Container(
              margin: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: context.watch<HomeNavigationProvider>().pageController,
                onPageChanged: (index) {},
                children: _pages,
              ),//_buildAnimatedSwitcher()
            ),
          ),
        );
      }
    );
  }

}