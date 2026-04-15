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

  // ✅ Capture le navigator AVANT l'opération async pour éviter
  // le context invalide au retour de la caméra/galerie (SDK 35 / Android 15)
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
    // ✅ Capture les deux navigators (dialog imbriqué + dialog parent)
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
                Navigator.of(context).pop(); // ✅ parenthèses manquantes corrigées
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