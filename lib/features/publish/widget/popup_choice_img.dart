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
import 'package:resilink_mobile_application/features/publish/provider/publish_provider.dart';
import 'package:flutter/material.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';
import 'package:resilink_mobile_application/features/publish/provider/offerImg_provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

class PopupChoiceImg extends StatefulWidget {
  const PopupChoiceImg({
    super.key,
    required this.offerImgProvider,
    required this.publishProvider,
  });

  final OfferImgProvider offerImgProvider;
  final PublishProvider publishProvider;

  @override
  State<PopupChoiceImg> createState() => _PopupChoiceImgState();
}

class _PopupChoiceImgState extends State<PopupChoiceImg> {

  // Capture the navigator BEFORE the async operation to avoid
  // invalid context when returning from camera/gallery (SDK 35 / Android 15)
  Future<void> _pickFromCamera() async {
    final navigator = Navigator.of(context);
    try {
      await widget.offerImgProvider.setImgWithPhoto();
      if (!mounted) return;
      final imgBase64 = await widget.offerImgProvider.convertImgToBase64();
      if (!mounted) return;
      widget.publishProvider.addElementImageList(imgBase64);
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      navigator.pop();
    }
  }

  Future<void> _pickFromGallery() async {
    final navigator = Navigator.of(context);
    try {
      await widget.offerImgProvider.setImgWithGallery();
      if (!mounted) return;
      final imgBase64 = await widget.offerImgProvider.convertImgToBase64();
      if (!mounted) return;
      widget.publishProvider.addElementImageList(imgBase64);
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      navigator.pop();
    }
  }

  Future<void> _pickFromAssets(String assetKey) async {
    // Capture both navigators (nested dialog + parent dialog)
    final innerNavigator = Navigator.of(context);
    widget.offerImgProvider.setImgWithDefaultImg(
      GlobalVariables.othersImage[assetKey]!,
    );
    final imgBase64 = await widget.offerImgProvider.convertImgToBase64();
    if (!mounted) return;
    widget.publishProvider.addElementImageList(imgBase64);
    innerNavigator.pop();
    innerNavigator.pop();
  }

  void _showAssetsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            AppLocalizations.of(dialogContext)!.popupFirstOptionImageTitle,
          ),
          content: SizedBox(
            width: MediaQuery.of(dialogContext).size.width,
            height: MediaQuery.of(dialogContext).size.height,
            child: GridView.builder(
              itemCount: GlobalVariables.othersImage.keys.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (BuildContext context, int index) {
                final key = GlobalVariables.othersImage.keys.elementAt(index);
                return GestureDetector(
                  onTap: () => _pickFromAssets(key),
                  child: Image.asset(
                    GlobalVariables.othersImage[key]!,
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        AppLocalizations.of(context)!.popupTitleChooseOptionImage,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAssetsDialog();
              },
              child: Text(
                AppLocalizations.of(context)!.popupFirstChooseOptionImage,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _pickFromCamera,
              child: Text(
                AppLocalizations.of(context)!.popupSecondChooseOptionImage,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _pickFromGallery,
              child: Text(
                AppLocalizations.of(context)!.popupThirdChooseOptionImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}