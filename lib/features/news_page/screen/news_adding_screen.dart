import 'package:resilink_mobile_application/common/widget/default_button.dart';
import 'package:resilink_mobile_application/features/news_page/provider/news_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../../../providers/locale_provider.dart';

// Widget for the languages page
class NewsAdding extends StatefulWidget {
  NewsAdding({super.key, required this.parentContext});

  BuildContext parentContext;

  @override
  NewsAddingState createState() => NewsAddingState();
}

class NewsAddingState extends State<NewsAdding> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
          // Creating the Publish provider in the tree structure
          create: (_) => NewsPageProvider(),
          builder: (context, child) {
            return Consumer<NewsPageProvider>(
              builder: (context, newsProvider, child) {
                return Directionality(
                  textDirection: TextDirection.ltr, // Needed when the language change
                  child: SafeArea(
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
                                AppLocalizations.of(context)!.languagePageTitle,
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
                        child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: (MediaQuery.of(context).size.height * 0.02)),
                                Text(
                                  AppLocalizations.of(context)!.newsAddingTitle,
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return TextFormField(
                                        clipBehavior: Clip.none,
                                        controller: newsProvider.instute,
                                        textAlignVertical: TextAlignVertical.bottom,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: AppLocalizations.of(context)!.newsAddingInstitute,
                                          labelText: "${AppLocalizations.of(context)!.newsAddingInstitute} *",
                                          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            color: GlobalVariables.tertiaryColor,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                            borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                            borderSide: const BorderSide(color: GlobalVariables.tertiaryColor, width: 2.0),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return TextFormField(
                                        clipBehavior: Clip.none,
                                        controller: newsProvider.url,
                                        textAlignVertical: TextAlignVertical.bottom,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: AppLocalizations.of(context)!.newsAddingUrl,
                                          labelText: "${AppLocalizations.of(context)!.newsAddingUrl} *",
                                          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            color: GlobalVariables.tertiaryColor,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                            borderSide: const BorderSide(color: GlobalVariables.unFocusBorderColor, width: 2.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                            borderSide: const BorderSide(color: GlobalVariables.tertiaryColor, width: 2.0),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    // Button to call up the language change function in the application
                                    child: DefaultButton(
                                        label: AppLocalizations.of(context)!.buttonConfirm,
                                        parentContext: context,
                                        function: null,
                                        futureFunction: () => newsProvider.createNews(widget.parentContext, context)
                                    )
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}
