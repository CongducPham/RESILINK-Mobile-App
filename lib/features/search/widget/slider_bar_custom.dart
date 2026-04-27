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
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/search/provider/search_provider.dart';

// A custom slider widget that allows users to select a distance value.
class SliderBarCustom extends StatefulWidget {
  SliderBarCustom({super.key, required this.searchProvider});

  final SearchProvider searchProvider;

  @override
  _SliderBarCustomState createState() => _SliderBarCustomState();
}

class _SliderBarCustomState extends State<SliderBarCustom> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4), // Primary color for the slider
        useMaterial3: true,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1, // Height of the slider container
        child: Stack(
          children: [
            Slider(
              max: 100,
              value: widget.searchProvider.distance,
              divisions: 20,
              label: widget.searchProvider.distance.round().toString(),
              onChanged: (double newValue) {
                widget.searchProvider.setDistance(newValue);
              },
              activeColor: GlobalVariables.primaryColor,
              thumbColor: GlobalVariables.primaryColor,
            ),
            Positioned(
              right: 10,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.searchProvider.distance.round().toString()} ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: GlobalVariables.textDefaultColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Km',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
