import 'package:Resilink/features/publish/provider/publish_provider.dart';
import 'package:flutter/material.dart';
import 'package:Resilink/constants/global_variables.dart';
import 'package:Resilink/features/publish/provider/offerImg_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// A widget that displays a popup dialog allowing the user to choose an image source (default images, camera, or gallery) for an offer.
class PopupChoiceImg extends StatelessWidget {
  PopupChoiceImg({super.key, required this.offerImgProvider, required this.publishProvider});

  OfferImgProvider offerImgProvider;
  PublishProvider publishProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      title: Text(AppLocalizations.of(context)!.popupTitleChooseOptionImage),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // 3 buttons in all
            children: [

              // Button that manages the recovery of images installed in the application's assets
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.popupFirstChooseOptionImage),
                onPressed: () {
                  Navigator.of(context).pop;
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: Text(AppLocalizations.of(context)!.popupFirstOptionImageTitle),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                            itemCount: GlobalVariables.assetTypeImages.keys.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1.1
                            ),
                            itemBuilder: (BuildContext context, int index) {

                              // Get the key at the current index
                              String key = GlobalVariables.othersImage.keys.elementAt(index);

                              return GestureDetector(
                                onTap: () async {
                                  offerImgProvider.setImgWithDefaultImg(GlobalVariables.othersImage[key]!);
                                  publishProvider.addElementImageList( await offerImgProvider.convertImgToBase64());
                                  print(publishProvider.imageList.length);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Image.asset(GlobalVariables.othersImage[key]!, fit: BoxFit.fill),
                              );
                            }
                        ),
                      ),
                    );
                  });
                },
              ),

              SizedBox(height: 10),

              // Button to manage image recovery with the camera
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.popupSecondChooseOptionImage),
                onPressed: () async {
                  offerImgProvider.setImgWithPhoto();
                  publishProvider.addElementImageList( await offerImgProvider.convertImgToBase64());
                  Navigator.of(context).pop;
                },
              ),

              SizedBox(height: 10),

              //Button to manage image recovery with the gallery
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.popupThirdChooseOptionImage),
                onPressed: () async {
                  offerImgProvider.setImgWithGallery();
                  publishProvider.addElementImageList( await offerImgProvider.convertImgToBase64());
                  Navigator.of(context).pop;
                },
              ),
            ],
          )
      )
    );
  }

}