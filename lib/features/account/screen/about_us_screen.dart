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