import 'package:flutter/material.dart';

import '../../constants/global_variables.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({super.key, required this.label, required this.parentContext, required this.function, required this.futureFunction});

  BuildContext parentContext;
  String label;
  Function? function;
  Future? futureFunction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          function != null ? function!() : await futureFunction;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,//GlobalVariables.backgroundColor,
          elevation: 0, // Disable elevation to keep same background color as scaffold widget
          side: const BorderSide(color: GlobalVariables.tersiaryColor),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: GlobalVariables.tersiaryColor
          ),
        )
    );
  }

}