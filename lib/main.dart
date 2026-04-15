import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart'; // <-- remplacer in_app_update par upgrader
import 'package:resilink_mobile_application/features/splash_screen/screen/splash_screen.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/features/home_navigation/screen/home_navigation_screen.dart';
import 'package:resilink_mobile_application/features/select_country/screen/select_country_screen.dart';
import 'package:resilink_mobile_application/main_service.dart';
import 'package:resilink_mobile_application/providers/locale_provider.dart';
import 'package:resilink_mobile_application/providers/main_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'common/service/AppLifecycleObserver.dart';
import 'constants/global_variables.dart';
import 'features/onboarding/screen/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  _MyAppState createState() => _MyAppState();

  static void resetApp(BuildContext context) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MainProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider())
        ],
        child: MyApp(),
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  bool _initialize = false;
  late AppLifecycleObserver lifecycleObserver;

  final HomeNavigation _homeNavigation = HomeNavigation();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await context.read<MainProvider>().migrateLocalDataIfNeeded();
    await context.read<MainProvider>().checkAndSetCountry();
    await context.read<LocaleProvider>().setInitialLocale();
    await context.read<MainProvider>().checkAndSetLocalIpAddress();
    await context.read<MainProvider>().loadOnboardingStatus();

    lifecycleObserver = AppLifecycleObserver(onAppResumed);
    setState(() {
      _initialize = true;
    });
  }

  Future<void> onAppResumed() async {
    if (!mounted) return;
    await context.read<MainProvider>().getUserDataAndToken();
  }

  @override
  void dispose() {
    lifecycleObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialize) {
      return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: GlobalVariables.backgroundColor,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    } else {
      return Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          final mainProvider = context.watch<MainProvider>();

          Widget startScreen;
          if (!mainProvider.hasCompletedOnboarding) {
            startScreen = SplashScreen();
          } else {
            startScreen = _homeNavigation;
          }

          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: GlobalVariables.backgroundColor,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              textTheme: GlobalVariables.appTextTheme,
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            locale: localeProvider.locale,
            home: UpgradeAlert(
              dialogStyle: UpgradeDialogStyle.material,
              showIgnore: false,
              showLater: false,
              barrierDismissible: false,
              child: startScreen,
            ),
          );
        },
      );
    }
  }
}
