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