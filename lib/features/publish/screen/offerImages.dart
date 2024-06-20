import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resilink_design/constants/global_variables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:resilink_design/features/publish/widget/popup_choice_img.dart';

import '../provider/offerImg_provider.dart';

class OfferImages extends StatefulWidget {
  const OfferImages({super.key});

  @override
  State<StatefulWidget> createState() {
    return OfferImagesState();
  }

}

class OfferImagesState extends State<OfferImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.45,
        padding: EdgeInsets.only(left: 25, right: 25),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.1
              ),
              itemBuilder: (context, index) {
                return ChangeNotifierProvider(
                  create: (_) => OfferImgProvider(),
                  builder: (context, child) {
                    return Consumer<OfferImgProvider>(
                      builder: (context, offerImgProvider, child) {
                        return GestureDetector(
                          onTap: () {
                            if (offerImgProvider.fileImg != null || offerImgProvider.pathDefaultImg.isNotEmpty) {
                              //TODO quand faudra faire le filtre, ne pas oublier de mettre à jour la liste de photos
                              offerImgProvider.cleanImg();
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return PopupChoiceImg(offerImgProvider: offerImgProvider);
                                }
                              );
                            }
                          },
                          child: offerImgProvider.fileImg != null ? Image.file(
                              offerImgProvider.fileImg!,
                              fit: BoxFit.fill,
                          ) : offerImgProvider.pathDefaultImg.isNotEmpty ? Image(
                              fit: BoxFit.fill,
                              image:  AssetImage(
                                  offerImgProvider.pathDefaultImg
                              )
                          ) : Container(
                              decoration: BoxDecoration(
                                color: GlobalVariables.navigationBarColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.add_a_photo,
                                    size: constraints.maxHeight * 0.1,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    AppLocalizations.of(context)!.publishImagesText,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        )
    );
  }

}