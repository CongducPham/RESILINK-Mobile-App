import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/features/home_navigation/screen/home_navigation_screen.dart';
import 'package:Resilink/features/select_country/screen/select_country_screen.dart';
import 'package:Resilink/main_service.dart';
import 'package:Resilink/providers/locale_provider.dart';
import 'package:Resilink/providers/main_provider.dart';

import 'constants/global_variables.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()), // Provides MainProvider for global state management.
        ChangeNotifierProvider(create: (_) => LocaleProvider()) // Provides LocaleProvider for global language management.
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialize = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // Initializes the app by checking and setting the country and locale language.
  Future<void> _initializeApp() async {
    await context.read<MainProvider>().checkAndSetCountry();
    await context.read<LocaleProvider>().setInitialLocale();
    setState(() {
      _initialize = true;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    /*
     * If _initializeApp is not finished, display a waiting screen.
     * Else, start the app normally.
     */

    if (!_initialize) {
      return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          useMaterial3: true, // can remove this line
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
              color: GlobalVariables.backgroundColor,
              child: Center(child: CircularProgressIndicator())
          ),
        ),
      );
    } else {
      return Consumer<LocaleProvider>( // Listening to LocaleProvider to access its data and manage them
        builder: (context, localeProvider, child) {
          return MaterialApp(
              theme: ThemeData(
                scaffoldBackgroundColor: GlobalVariables.backgroundColor,
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
                useMaterial3: true, // can remove this line
              ),
              debugShowCheckedModeBanner: false, // Hides the debug banner.
              // Add localization support
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),  // Anglais
                const Locale('ar', ''),  // Français
              ],
              //define the locale langage
              locale: localeProvider.locale,
              // Directs to the HomeNavigation screen if the country is set, otherwise to the SelectCountryScreen.
              home: context.read<MainProvider>().countryExist ? HomeNavigation() : SelectCountryScreen()
          );
        },
      );
    }
  }
}


