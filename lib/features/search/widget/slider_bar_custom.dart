import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/search/provider/search_provider.dart';

class SliderBarCustom extends StatefulWidget {
  SliderBarCustom({super.key, required this.searchProvider});

  SearchProvider searchProvider;

  @override
  _SliderBarCustomState createState() => _SliderBarCustomState();
}

class _SliderBarCustomState extends State<SliderBarCustom> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
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
            const Positioned(
              right: 10,
              child: Text(
                'Km',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}