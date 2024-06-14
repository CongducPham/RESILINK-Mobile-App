import 'package:flutter/material.dart';

import '../../constants/global_variables.dart';

class TextFieldInfo extends StatelessWidget {
  TextFieldInfo({super.key, required this.textController, required this.label, required this.parentContext});

  TextEditingController textController;
  String label;
  BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Column(
        children : [
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(parentContext).size.height * 0.070,
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: TextFormField(
                controller: textController,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                    fontSize: 13
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(
                    color: GlobalVariables.tersiaryColor,
                    fontSize: 16.0,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: GlobalVariables.tersiaryColor, width: 2.0),
                  ),
                ),
              ),
            ),
          ),
        ]
    );
  }

}