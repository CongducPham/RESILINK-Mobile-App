import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/common/widget/default_button.dart';
import 'package:resilink_design/common/widget/textfield_info.dart';

import '../../../constants/global_variables.dart';
import '../provider/sign_up_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }

}

class SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
                title: const Center(
                    child: Text(
                        "Inscription",
                        style: TextStyle(
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
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container(
                              margin: const EdgeInsets.only(right: 10, bottom: 15),
                              child: TextFieldInfo(textController: context.read<SignUpProvider>().firstname, label: "FirstName", parentContext: context))),
                          Expanded(child: Container(
                              margin: const EdgeInsets.only(left: 10, bottom: 15),
                              child: TextFieldInfo(textController: context.read<SignUpProvider>().lastname, label: "LastName", parentContext: context))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Container(
                              margin: const EdgeInsets.only(right: 10, bottom: 15),
                              child: TextFieldInfo(textController: context.read<SignUpProvider>().username, label: "UserName", parentContext: context))),
                          Expanded(child: Container(
                              margin: const EdgeInsets.only(left: 10, bottom: 15),
                              child: TextFieldInfo(textController: context.read<SignUpProvider>().phoneNumber, label: "Phone number", parentContext: context))),

                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFieldInfo(textController: context.read<SignUpProvider>().job, label: "Job", parentContext: context)),
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFieldInfo(textController: context.read<SignUpProvider>().email, label: "Email", parentContext: context)),
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFieldInfo(textController: context.read<SignUpProvider>().password, label: "Password", parentContext: context)),

                      if (context.watch<SignUpProvider>().error)
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: const Center(
                              child: Text("Your password need atleast 6 caracteres",
                                  style: TextStyle(
                                      color: Colors.red
                                  )),
                            )
                        ),
                      const SizedBox(height: 10),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: DefaultButton(label: "Sign up", parentContext: context, function: null, futureFunction: null)),
                      const SizedBox(height: 10),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                              "Already an account? Sign in here",
                              style: TextStyle(fontSize: 13,
                                  color: Colors.lightBlueAccent)
                          )
                      ),
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}