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
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import '../../../common/service/Launch_in_external_app.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Material(
            color: GlobalVariables.headerBackgroundColor,
            elevation: 4,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.accountSubTitleAboutUs,
                  style: const TextStyle(color: GlobalVariables.textHeaderColor),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---- Main title ----
              Text(
                AppLocalizations.of(context)!.aboutUsFirstTitle,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // ---- Main styled paragraph ----
              Text(
                "${AppLocalizations.of(context)!.aboutUsDescription1}\n\n"
                "${AppLocalizations.of(context)!.aboutUsDescription2}\n\n"
                "${AppLocalizations.of(context)!.aboutUsDescription3}",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 35),

              // ---- Links section ----
              Text(
                AppLocalizations.of(context)!.aboutUsSecondTitle,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // ---- Website button ----
              ElevatedButton.icon(
                onPressed: () async => await launchInBrowser(Uri.parse(GlobalVariables.websiteUrl)),
                icon: const Icon(Icons.language),
                label: Text(AppLocalizations.of(context)!.aboutUsFirstLink),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 12),

              // ---- Privacy Policy button ----
              OutlinedButton.icon(
                onPressed: () async => await launchInBrowser(Uri.parse(GlobalVariables.privacyUrl)),
                icon: const Icon(Icons.privacy_tip_outlined),
                label: Text(AppLocalizations.of(context)!.aboutUsSecondLink),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}