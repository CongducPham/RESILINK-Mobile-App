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
import 'package:resilink_mobile_application/features/select_country/screen/select_country_screen.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../home/screen/home_screen.dart';
import '../provider/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key, this.fromParameters = false});
  final bool fromParameters;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(),
      builder: (context, _) {
        final provider = context.watch<OnboardingProvider>();

        provider.initializeSlides(context);

        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: provider.setPage,
                      children: provider.slides.map((slide) {
                        return OnboardSlide(image: slide.image, text: slide.text);
                      }).toList(),
                    ),
                  ),

                  SmoothPageIndicator(
                    controller: _controller,
                    count: provider.slides.length,
                    effect: WormEffect(),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: () async {
                      if (provider.currentPage == provider.slides.length - 1) {
                        await provider.finishOnboarding();
                        if (fromParameters) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SelectCountryScreen()),
                          );
                        }

                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Text(provider.currentPage == provider.slides.length - 1 ? AppLocalizations.of(context)!.buttonStart : AppLocalizations.of(context)!.onboardingButtonNext),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class OnboardSlide extends StatelessWidget {
  final String image;
  final String? text;

  const OnboardSlide({
    required this.image,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasText = text != null && text!.trim().isNotEmpty;

    return Column(
      children: [
        Expanded(
          flex: hasText ? 12 : 9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 20),

        if (hasText) ...[
          const SizedBox(height: 18),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ],
    );
  }
}

