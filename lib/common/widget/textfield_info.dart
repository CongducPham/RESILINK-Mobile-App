import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/global_variables.dart';

class TextFieldInfo extends StatelessWidget {
  TextFieldInfo({super.key, required this.textController, required this.label, required this.parentContext, required this.isNumeric});

  // inherited variables
  TextEditingController textController;
  String label;
  BuildContext parentContext;
  bool isNumeric;

  // local variables
  String _previusText = "";

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
                inputFormatters: [
                  if (label == "email")
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                ],
                onChanged: (String value) {

                  // regex to detect text not in roman script
                  final RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');

                  // Checks whether the text respects the regex and whether the current text size is larger than its previous value.
                  // If so, displays a warning SnackBar.
                  if (arabicRegExp.hasMatch(textController.text) && _previusText.length < value.length) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.snackBarBadKeyboard),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                  _previusText = value;
                },
                decoration: InputDecoration(
                  isDense: true,
                  labelText: label,
                  labelStyle: const TextStyle(
                    color: GlobalVariables.tertiaryColor,
                    fontSize: 16.0,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: GlobalVariables.tertiaryColor, width: 2.0),
                  ),
                ),
                keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              ),
            ),
          ),
        ]
    );
  }

}