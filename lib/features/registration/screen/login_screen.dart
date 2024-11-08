import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/common/widget/textfield_info.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:Resilink/features/registration/provider/login_provider.dart';
import 'package:Resilink/features/registration/screen/sign_up_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Resilink/providers/main_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {

    // local variable for screen size
    double h = MediaQuery.of(context).size.height;

    return SizedBox(
      height: h,
      child: SingleChildScrollView(

        // Using BouncingScrollPhysics so that scrolling does not increase screen size in a predefined way
        physics: const BouncingScrollPhysics(),
        child: ChangeNotifierProvider(

          // Creating the Login provider in the tree structure
          create: (_) => LoginProvider(),
          builder: (context, child) {
            return Consumer3<LoginProvider, MainProvider, HomeNavigationProvider>( // Listening to Login, HomeNavigation and Main providers to access their data
              builder: (context, loginProvider, userProvider, homeNavigationProvider, child) {
                return Column( // Column with text fields for user id and password, an access to the registration page and a button to confirm user registration
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: h * 0.1),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                          AppLocalizations.of(context)!.registerLoginTitle,
                          style: TextStyle(fontSize: 40)
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        TextFieldInfo(textController: loginProvider.username, label: AppLocalizations.of(context)!.registerLoginFirstLabel, parentContext: context, isNumeric: false,),
                        TextFieldInfo(textController: loginProvider.password, label: AppLocalizations.of(context)!.registerLoginSecondLabel, parentContext: context, isNumeric: false,)
                      ],
                    ),

                    // If something has gone wrong, a warning is displayed
                    if (loginProvider.error)
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Text(
                          AppLocalizations.of(context)!.registerLoginErrorConnexion,
                          style: const TextStyle(
                              color: Colors.red
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),

                    // Login button
                    Container(
                        alignment: Alignment.bottomRight,
                        child: DefaultButton(
                            label: AppLocalizations.of(context)!.buttonSignIn,
                            parentContext: context, function: null,
                            futureFunction: () => loginProvider.signIn(context, userProvider, homeNavigationProvider)
                        )
                    ),

                    // textButton equivalent to access registration page
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(homeNavigationProvider: homeNavigationProvider,)));
                        },
                        child: Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(
                              AppLocalizations.of(context)!.registerLoginRedirection,
                              style: const TextStyle(fontSize: 13, color: Colors.lightBlueAccent)
                          ),
                        )
                    ),
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }

}
