import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../constants/global_variables.dart';

class TextFieldInfo extends StatefulWidget {
  TextFieldInfo({
    super.key,
    required this.textController,
    required this.label,
    required this.parentContext,
    required this.isNumeric,
    this.testHint,
    this.obscureText = false,
  });

  // Inherited variables
  final TextEditingController textController;
  final String label;
  final String? testHint;
  final BuildContext parentContext;
  final bool isNumeric;
  final bool obscureText;

  @override
  State<TextFieldInfo> createState() => _TextFieldInfoState();
}

class _TextFieldInfoState extends State<TextFieldInfo> {
  String _previousText = "";
  bool _isObscured = false; // Local variable to manage obscured text display

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: 1.1,
                child: SizedBox(
                  height: MediaQuery.of(widget.parentContext).size.height * 0.070,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                      child: TextFormField(
                        clipBehavior: Clip.none,
                        controller: widget.textController,
                        obscureText: _isObscured, // Manages obscured text display
                        textAlignVertical: widget.testHint != null
                            ? TextAlignVertical.bottom
                            : TextAlignVertical.top,
                        // Input text style — bodyMedium for compact form fields
                        style: Theme.of(context).textTheme.bodyMedium,
                        inputFormatters: [
                          if (widget.label == "email")
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                        ],
                        onChanged: (String value) {
                          final RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');

                          if (arabicRegExp.hasMatch(widget.textController.text) &&
                              _previousText.length < value.length) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.snackBarBadKeyboard),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                          _previousText = value;
                        },
                        decoration: InputDecoration(
                          hintText: widget.testHint,
                          isDense: true,
                          labelText: widget.label,
                          // labelStyle kept as-is: functional floating label style,
                          // not a content typography role
                          labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: GlobalVariables.tertiaryColor,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                color: GlobalVariables.unFocusBorderColor, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                color: GlobalVariables.tertiaryColor, width: 2.0),
                          ),
                          suffixIcon: widget.obscureText
                              ? IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility : Icons.visibility_off,
                              color: GlobalVariables.tertiaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          )
                              : null,
                        ),
                        keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}