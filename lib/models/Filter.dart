
import 'FilterSpecificAttr.dart';

class Filter {

  String? _beginTime;
  String? _endTime;
  String? _validityTime;
  String? _transactionType;
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

  Map<String, dynamic> getMapFilter () {
    Map<String, dynamic> Filter = {
      if (_assetType != null) "assetType": _assetType,
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