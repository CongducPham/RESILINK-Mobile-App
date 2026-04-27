/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
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