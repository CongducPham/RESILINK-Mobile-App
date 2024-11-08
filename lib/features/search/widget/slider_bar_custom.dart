import 'package:flutter/material.dart';
import 'package:Resilink/features/search/provider/search_provider.dart';

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
              activeColor: Colors.purple,
              thumbColor: Colors.purple,
            ),
            Positioned(
              right: 10,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.searchProvider.distance.round().toString()} ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.purple, // Couleur violette pour la distance
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Km',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Couleur noire pour "Km"
                        fontWeight: FontWeight.w500,
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
