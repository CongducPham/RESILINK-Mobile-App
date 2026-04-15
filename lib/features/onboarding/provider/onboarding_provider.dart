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
