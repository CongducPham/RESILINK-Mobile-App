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
import 'FilterSpecificAttr.dart';

class Filter {

  String? _beginTime;
  String? _endTime;
  String? _validityTime;
  String? _transactionType;
  String? _country;
  String? _assetType;
  String? _name;
  String? _cityVillage;
  num? _maxPrice;
  num? _maxDeposit;
  int? _maxQuantity;
  int? _minQuantity;
  double? _latitude;
  double? _longitude;
  double? _distanceKilometer;

  List<FilterSpecificAttr> _mapSpec = [];

  String get assetType => _assetType ?? "";

  void setCountry(String country) {
    _country = country;
  }

  void setDistanceKilometer(double value) {
    _distanceKilometer = value;
  }

  void setBeginTime (String beginTime){
    if (beginTime != "" && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$',).hasMatch(beginTime)) {
      _beginTime = beginTime;
    }
  }

  void setName (String name){
    if (name != null && name != "") {
      _name = name;
    }
  }

  void clearName() {
    _name = null;
  }

  void setCityVillage (String cityVillage){
    if (cityVillage != null && cityVillage != "") {
      _cityVillage = cityVillage;
    }
  }

  void setEndTime (String endTime){
    if (endTime != "" && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$',).hasMatch(endTime)) {
      _endTime = endTime;
    }
  }

  void setValidityTime (String validityTime){
    if (validityTime != "" && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$',).hasMatch(validityTime)) {
      _validityTime = validityTime;
    }
  }

  void setTransactionType (String transactiontype){
    if (transactiontype != "none" && transactiontype != "Both") {
      _transactionType = transactiontype;
    }
  }

  void setAssetType (String assettype){
    if (assettype != "none") {
      _assetType = assettype;
    }
  }

  void setMaxPrice (num? maxprice) {
    if (maxprice != null) {
      _maxPrice = maxprice;
    }
  }

  void setMaxDeposit (num? maxdeposit) {
    if (maxdeposit != null) {
      _maxDeposit = maxdeposit;
    }
  }

  void setMaxQuantity (int? maxquantity) {
    if (maxquantity != null) {
      _maxQuantity = maxquantity;
    }
  }

  void setMapSpec (List<FilterSpecificAttr> mapSpec) {
     _mapSpec.addAll(mapSpec);
  }

  void setCoordinate(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
  }

  void clearCoordinate() {
    _latitude = null;
    _longitude = null;
  }

  Map<String, dynamic> getMapFilter () {
    Map<String, dynamic> Filter = {
      if (_assetType != null) "assetType": _assetType,
      if (_country != null) "country": _country,
      if (_name != null) "name": _name,
      if (_maxQuantity != null) "maxQuantity": _maxQuantity,
      if (_minQuantity != null) "minQuantity": _minQuantity,
      if (_maxDeposit != null) "maxDeposit": _maxDeposit,
      if (_mapSpec.isNotEmpty) "properties": _mapSpec,
      if (_maxPrice != null) "maxPrice": _maxPrice,
      if (_transactionType != null) "transactionType": _transactionType,
      if (_validityTime != null) "ValidityTime": _validityTime,
      if (_beginTime != null) "minDate": _beginTime,
      if (_endTime != null) "maxDate": _endTime,
      if (_latitude != null) "latitude": _latitude,
      if (_longitude != null) "longitude": _longitude,
      if (_distanceKilometer != null) "distance": _distanceKilometer,
      if (_cityVillage != null) "cityVillage": _cityVillage
    };
    return Filter;
  }
}