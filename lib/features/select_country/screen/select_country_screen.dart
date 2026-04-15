import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import '../../../common/widget/default_button.dart';
import '../../../providers/main_provider.dart';
import '../../home_navigation/screen/home_navigation_screen.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key, this.fromParameters = false});
  final bool fromParameters;

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  String? selectedCountry;
  final List<String> countryKeys = ['algeria', 'egypt', 'morocco'];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: widget.fromParameters
            ? PreferredSize(
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
                  AppLocalizations.of(context)!.accountSubTitleLocalization,
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
        )
            : null,
        body: Stack(
          children: [
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Image(
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  image: AssetImage(GlobalVariables.othersImage['resilinkLogo']!),
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Page title — headlineMedium for a prominent centered heading
                    Text(
                      loc.chooseCountry,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedCountry,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: loc.chooseCountry,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.flag_circle_outlined),
                      ),
                      items: countryKeys.map((key) {
                        return DropdownMenuItem(
                          value: key,
                          child: Text(_getLocalizedCountryName(key, loc)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedCountry = val),
                    ),
                    const SizedBox(height: 30),
                    Opacity(
                      opacity: selectedCountry == null ? 0.3 : 1,
                      child: IgnorePointer(
                        ignoring: selectedCountry == null,
                        child: DefaultButton(
                          label: loc.buttonConfirm,
                          parentContext: context,
                          function: null,
                          futureFunction: () async {
                            await context.read<MainProvider>().setCountry(selectedCountry!);
                            if (widget.fromParameters) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeNavigation()),
                              );
                            }
                          },
                        ),
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

  String _getLocalizedCountryName(String key, AppLocalizations loc) {
    switch (key) {
      case 'algeria':
        return loc.algeria;
      case 'egypt':
        return loc.egypt;
      case 'morocco':
        return loc.morocco;
      default:
        return key;
    }
  }
}