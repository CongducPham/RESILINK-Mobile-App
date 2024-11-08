import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Resilink/common/widget/default_button.dart';
import 'package:Resilink/common/widget/textfield_info.dart';
import 'package:Resilink/features/home_navigation/provider/home_navigation_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../../../providers/main_provider.dart';
import '../provider/sign_up_provider.dart';


// Registration widget, widget displaying the registration page. Page separate from main navigation

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key, required this.homeNavigationProvider});

  HomeNavigationProvider homeNavigationProvider;
  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }

}

class SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          /*
           * AppBar with 3 elements :
           * - Language-dependent title change (see file in lib/features/l10n)
           * - A navigation arrow to return to the login page
           * - A bell for notifications TODO notifications to be implemented or removed if necessary
           */
          appBar: AppBar(
              title: Center(
                  child: Text(
                      AppLocalizations.of(context)!.registerSignUpTitle,
                      style: const TextStyle(
                          color: GlobalVariables.textHeaderColor
                      )
                  )
              ),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: Colors.transparent),
                onPressed: () {
                  //TODO to complete if notification page/features is implemented
                },
              ),
            ],
          ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ChangeNotifierProvider(
                  create: (_) => SignUpProvider(),
                  builder: (context, child) {
                    return Consumer2<SignUpProvider, MainProvider>( // Listening to SignUp and Main providers to access their data
                      builder: (context, signUpProvider, mainProvider, child) {

                        return Container(
                          margin: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                          height: MediaQuery.of(context).size.height,
                          child: Column( // Column with text fields for user data, a second access to the login page and a button to confirm user registration
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 10, bottom: 15),
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: TextFieldInfo(textController: signUpProvider.firstname, label: "${AppLocalizations.of(context)!.accountLabelFirstname} *", parentContext: context, isNumeric: false,)),
                                  Container(
                                      margin: const EdgeInsets.only(left: 10, bottom: 15),
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: TextFieldInfo(textController: signUpProvider.lastname, label: "${AppLocalizations.of(context)!.accountLabelLastname} *", parentContext: context, isNumeric: false,)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 10, bottom: 15),
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: TextFieldInfo(textController: signUpProvider.username, label: "${AppLocalizations.of(context)!.accountLabelUsername} *", parentContext: context, isNumeric: false,)),
                                  Container(
                                      margin: const EdgeInsets.only(left: 10, bottom: 15),
                                      width: MediaQuery.of(context).size.width * 0.35,

                                      child: TextFieldInfo(textController: signUpProvider.phoneNumber, label: "${AppLocalizations.of(context)!.labelPhoneNumber} *", parentContext: context, isNumeric: true,))
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: TextFieldInfo(textController: signUpProvider.job, label: AppLocalizations.of(context)!.accountLabelJob, parentContext: context, isNumeric: false,)),
                              Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: TextFieldInfo(textController: signUpProvider.email, label: "${AppLocalizations.of(context)!.labelEmail} *", parentContext: context, isNumeric: false,)),
                              TextFieldInfo(textController: signUpProvider.password, label: "${AppLocalizations.of(context)!.registerLoginSecondLabel} *", parentContext: context, isNumeric: false,),

                              if (context.watch<SignUpProvider>().error && signUpProvider.password.text.length < 6)
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: Center(
                                      child: Text(AppLocalizations.of(context)!.registerSignUpErrorPassword,
                                          style: const TextStyle(
                                              color: Colors.red
                                          )),
                                    )
                                ),

                              // Registration button
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: DefaultButton(
                                      label: AppLocalizations.of(context)!.buttonSignUp,
                                      parentContext: context, function: null,
                                      futureFunction: () => signUpProvider.signUp(context, mainProvider, widget.homeNavigationProvider)
                                  )
                              ),
                              const SizedBox(height: 10),

                              // textButton equivalent to access login page
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.registerSignUpRedirection,
                                      style: const TextStyle(fontSize: 13,
                                          color: Colors.lightBlueAccent)
                                  )
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
        ),
      );
  }
}