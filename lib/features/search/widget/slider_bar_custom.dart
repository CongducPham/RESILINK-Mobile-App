import 'package:flutter/material.dart';

class SliderBarCustom extends StatefulWidget {
  SliderBarCustom({super.key, required this.currentValue});

  double currentValue;

  @override
  _SliderBarCustomState createState() => _SliderBarCustomState();
}

class _SliderBarCustomState extends State<SliderBarCustom> {

  late double actualValue;

  @override
  void initState() {
    actualValue = widget.currentValue;
    super.initState();
  }

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
              value: actualValue,
              divisions: 100,
              label: actualValue.round().toString(),
              onChanged: (double newValue) {
                setState(() {
                  actualValue = newValue;
                });
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