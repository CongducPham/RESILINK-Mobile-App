import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/home_navigation/screen/home_navigation_screen.dart';
import 'package:resilink_design/features/select_country/screen/select_country_screen.dart';
import 'package:resilink_design/main_service.dart';
import 'package:resilink_design/providers/user_provider.dart';

import 'constants/global_variables.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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

  Future<void> _initializeApp() async {
    await (context.read<UserProvider>().checkAndSetCountry());
    setState(() {
      _initialize = true;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Enter if the checks and initialisation, if possible, of the country and User variables have been completed.
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
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
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
            // Ajout du support de localisation
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
            locale: context.read<UserProvider>().locale,
            home: context.read<UserProvider>().countryExist ? HomeNavigation() : SelectCountryScreen()
        );
      },
    );
  }
}


