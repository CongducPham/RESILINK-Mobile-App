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
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';
import 'package:resilink_mobile_application/features/publish/widget/popup_choice_img.dart';

import '../../../providers/main_provider.dart';
import '../provider/offerImg_provider.dart';
import '../provider/publish_provider.dart';

// Widget to manage offer images
class OfferImages extends StatefulWidget {
  OfferImages({super.key, required this.publishProvider,});

  PublishProvider publishProvider;

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
            .height * 0.225,
        padding: EdgeInsets.only(left: 25, right: 25),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.1
              ),
              itemBuilder: (context, index) {
                return ChangeNotifierProvider(
                // Creating the OfferImg provider in the tree structure
                create: (_) => OfferImgProvider(),
                  builder: (context, child) {
                    return Consumer<OfferImgProvider>( // Listening to OfferImg providers to access their data
                      builder: (context, offerImgProvider, child) {
                        return GestureDetector(
                          /*
                           * If an image is already stocked, delete it
                           * Else displays a popup to take a picture from multiple choices
                           */
                          onTap: () {
                            if (offerImgProvider.fileImg != null || offerImgProvider.pathDefaultImg.isNotEmpty || ( widget.publishProvider.imageList.length > index && widget.publishProvider.imageList[index] != null)) {
                              widget.publishProvider.removeElementImageList(index);
                              offerImgProvider.cleanImg();
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return PopupChoiceImg(
                                      offerImgProvider: offerImgProvider,
                                      publishProvider: widget.publishProvider
                                  );
                                }
                              );
                            }
                          },
                          // Display the image (depending on where it was taken, the display method is not the same)
                          child: offerImgProvider.fileImg != null ? Image.file(
                              offerImgProvider.fileImg!,
                              fit: BoxFit.fill,
                          ) : offerImgProvider.pathDefaultImg.isNotEmpty ? Image(
                              fit: BoxFit.fill,
                              image:  AssetImage(
                                  offerImgProvider.pathDefaultImg
                              )
                          ) : ( widget.publishProvider.imageList.length > index && widget.publishProvider.imageList[index] != null) ? widget.publishProvider.imageList[index].toString().contains("https://") ?
                          Image.network(
                            widget.publishProvider.imageList[index],
                            fit: BoxFit.fill,
                          ) : Image.memory (
                            context.read<MainProvider>().convertBase64ToImg(widget.publishProvider.imageList[index]),
                          ) :
                          // If not image is stocked, displays the default "add image" container
                          Container(
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
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
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