import 'package:flutter/material.dart';
import 'package:resilink_design/features/select_country/service/select_country_services.dart';
import 'package:resilink_design/features/splash_screen/screen/splash_screen.dart';

import '../../../constants/global_variables.dart';

class FlagTouch {

 Widget flagTouchNavigator(String text, String imageKey, double maxWidth, double maxHeight, BuildContext context, String country) {
   return GestureDetector(
     onTap: () {
       SelectCountryService().setCountry(country);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
     },
     child: Column(
       children: [
         Container(
           decoration: BoxDecoration(
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.5), // Couleur de l'ombre
                 spreadRadius: 1, // Rayon de diffusion
                 blurRadius: 3, // Rayon de flou
                 offset: const Offset(0, 2), // Décalage de l'ombre
               ),
             ],
           ),
           child: Image(
               fit: BoxFit.fill,
               height: maxHeight * 0.20,
               width: maxWidth * 0.50,
               image: AssetImage(GlobalVariables.othersImage[imageKey]!)
           ),
         ),
         Align(
           alignment: Alignment.centerRight,
           child: Text(
             text,
             style: const TextStyle(
                 fontSize: 13,
                 fontWeight: FontWeight.w500
             ),
           ),
         ),
       ],
     ),
   );
 }

}