import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/select_country/screen/select_country_screen.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        //to take the phone's location
        /*
          localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
         */
        /*supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
          Locale('ar', ''),
        ],

         */
        //define the locale langage
        //locale: _locale,
        home: SelectCountryScreen()
    );
  }
}


