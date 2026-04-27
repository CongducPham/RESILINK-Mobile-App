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
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resilink_mobile_application/constants/global_variables.dart';

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