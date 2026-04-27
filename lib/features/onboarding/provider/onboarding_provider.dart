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
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/providers/locale_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import '../../../main_service.dart';

class OnboardingProvider extends ChangeNotifier {
  int currentPage = 0;
  late List<OnboardingSlideData> slides;
  final MainService _mainService = MainService();

  void initializeSlides(BuildContext context) {
    final folder = context.read<LocaleProvider>().valueLocale;

    slides = [
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_1.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_2.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_3.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_4.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_5.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_6.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_7.png"),
      OnboardingSlideData("assets/images/onboarding/$folder/onboarding_splash_8.png"),
    ];
  }

  void setPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    await _mainService.setOnboardingCompleted();
  }
}

class OnboardingSlideData {
  final String image;
  final String? text;

  OnboardingSlideData(this.image, [this.text]);
}
