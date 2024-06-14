import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/common/widget/textfield_info.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:resilink_design/features/registration/provider/login_provider.dart';
import 'package:resilink_design/features/registration/screen/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen> {

  String labelUsername = "Username";
  String labelPassword = "Password";

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return SizedBox(
      height: h,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.1),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 40)
              ),
            ),
            const SizedBox(height: 30),
            ChangeNotifierProvider(
              create: (_) => LoginProvider(),
              builder: (context, child) {
                return Column(
                  children: [
                    TextFieldInfo(textController: context.read<LoginProvider>().username, label: labelUsername, parentContext: context,),
                    TextFieldInfo(textController: context.read<LoginProvider>().password, label: labelPassword, parentContext: context,)
                  ],
                );
              },
            ),
            if (false)
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Text(
                  "Wrong username or password, try again",
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Container(
                alignment: Alignment.bottomRight,
                child: DefaultButton(label: "Sign In", parentContext: context, function: null, futureFunction: null)),
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                      "No account? Sign up here >>",
                      style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent)
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

}
