import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resilink_design/constants/global_variables.dart';

class OfferImgProvider extends ChangeNotifier {

  OfferImgProvider();

  final ImagePicker _img = ImagePicker();
  XFile? _file = null;
  String _pathDefaultImg = "";
  File? _fileImg = null;

  XFile? get file => _file;
  String get pathDefaultImg => _pathDefaultImg;
  File? get fileImg => _fileImg;

  void setImgWithDefaultImg(String img) {
    _pathDefaultImg = img;
    _file = null;
    _fileImg = null;
    notifyListeners();
  }

  void setImgWithPhoto() async {
    _file = await _img.pickImage(source: ImageSource.camera);
    if (_file != null) {
      _fileImg = File(_file!.path);
      _pathDefaultImg = "";
      _file = null;
      notifyListeners();
    }
  }

  void setImgWithGallery() async {
    _file = await _img.pickImage(source: ImageSource.gallery);
    if (_file != null) {
      _fileImg = File(_file!.path);
      _pathDefaultImg = "";
      _file = null;
      notifyListeners();
    }
  }

  //TODO a supprimer, utilisé uniquement pour la version navigation
  void setImgTest() {
    _pathDefaultImg = GlobalVariables.othersImage["banana"]!;
    notifyListeners();
  }

  void cleanImg() {
    _fileImg = null;
    _pathDefaultImg = "";
    _file = null;
    notifyListeners();
  }
}