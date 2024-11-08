import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Resilink/constants/global_variables.dart';

class OfferImgProvider extends ChangeNotifier {

  // Constructor
  OfferImgProvider();

  // Variables and their initialization
  final ImagePicker _img = ImagePicker();
  XFile? _file = null;
  String _pathDefaultImg = "";
  File? _fileImg = null;


  // Getters
  XFile? get file => _file;
  String get pathDefaultImg => _pathDefaultImg;
  File? get fileImg => _fileImg;

  // Setters

  // Set an image with its path and XFile value within the default images within application
  void setImgWithDefaultImg(String img) {
    _pathDefaultImg = img;
    _file = null;
    _fileImg = null;
    notifyListeners();
  }

  // Set an image with its path and XFile value within the camera
  Future<void> setImgWithPhoto() async {
    _file = await _img.pickImage(source: ImageSource.camera);
    if (_file != null) {
      _fileImg = File(_file!.path);
      _pathDefaultImg = "";
      _file = null;
      notifyListeners();
    }
  }

  // Set an image with its path and XFile value within the phone gallery
  Future<void> setImgWithGallery() async {
    _file = await _img.pickImage(source: ImageSource.gallery);
    if (_file != null) {
      _fileImg = File(_file!.path);
      _pathDefaultImg = "";
      _file = null;
      notifyListeners();
    }
  }

  /*
   * Try to find is the image is in the assets of the mobile application
   * If image find, return the image in bytes form
   * If not find, return null
   */
  Future<List<int>> _imgBundleToByte(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    List<int> bytes = data.buffer.asUint8List();
    return bytes;
  }

  // Convert the image (whether from a gallery, camera or asset) to base64
  Future<String> convertImgToBase64 () async {
    late List<int> imageBytes;
    if (_pathDefaultImg.contains("img/")) {
      imageBytes = await _imgBundleToByte(_pathDefaultImg);
    } else {
      print(_fileImg);
      imageBytes = _fileImg!.readAsBytesSync();
    }
    return (base64Encode(imageBytes));
  }

  // Set all value to null to delete the image
  void cleanImg() {
    _fileImg = null;
    _pathDefaultImg = "";
    _file = null;
    notifyListeners();
  }
}