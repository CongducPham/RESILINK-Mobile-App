import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/features/news_page/provider/news_page_provider.dart';

import 'list_news_account_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewsScreenState();
  }
}

class NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "List of News Source",
              style: TextStyle(
                fontSize: 24,
              ),
            )
          ),
          const SizedBox(height: 15),
          ChangeNotifierProvider(
              create: (_) => NewsPageProvider(),
              builder: (context, child) {
                if (context.watch<NewsPageProvider>().isLoading) {
                  return SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 1.5,
                      child: const Center(child: CircularProgressIndicator())
                  );
                }

                if (context.watch<NewsPageProvider>().listNews.isEmpty) {
                  return SizedBox(
                      width: MediaQuery
                          .of(this.context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(this.context)
                          .size
                          .height / 1.5,
                      child: const Center(child: Text("no news available"))
                  );
                }

                return ListBookmarked(newsList: context.watch<NewsPageProvider>().listNews, maxLength: 5, fromProfil: false, deletion: false);
              }


          )
        ]
      )
    );
  }
}
