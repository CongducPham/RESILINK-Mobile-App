
import 'FilterSpecificAttr.dart';

class Filter {

  String? _BeginTime;
  String? _EndTime;
  String? _ValidityTime;
  String? _TransactionType;
  String? _AssetType;
  String? _Name;
  num? _MaxPrice;
  num? _MaxDeposit;
  int? _MaxQuantity;
  int? _MinQuantity;
  double? _latitude;
  double? _longitude;
  double? _distanceKilometer;

  List<FilterSpecificAttr> _MapSpec = [];

  String get assetType => _AssetType ?? "";

  void setDistanceKilometer(double value) {
    _distanceKilometer = value;
  }

  void setBeginTime (String beginTime){
    if (beginTime != "" && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$',).hasMatch(beginTime)) {
      _BeginTime = beginTime;
      print("passer begintime : $_BeginTime");
    }
  }

  void setName (String name){
    if (name != null && name != "") {
      _Name = name;
      print("passer endtime : $_EndTime");
    }
  }

  void setEndTime (String endTime){
    if (endTime != "" && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$',).hasMatch(endTime)) {
      _EndTime = endTime;
      print("passer endtime : $_EndTime");
    }
  }

  void setValidityTime (String validityTime){
    if (validityTime != "" && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$',).hasMatch(validityTime)) {
      _ValidityTime = validityTime;
      print("passer validitytime :  $_ValidityTime");
    }
  }

  void setTransactionType (String transactiontype){
    if (transactiontype != "none" && transactiontype != "Both") {
      _TransactionType = transactiontype;
    }
  }

  void setAssetType (String assettype){
    if (assettype != "none") {
      _AssetType = assettype;
    }
  }

  void setMaxPrice (num? maxprice) {
    if (maxprice != null) {
      _MaxPrice = maxprice;
    }
  }

  void setMaxDeposit (num? maxdeposit) {
    if (maxdeposit != null) {
      _MaxDeposit = maxdeposit;
    }
  }

  void setMaxQuantity (int? maxquantity) {
    if (maxquantity != null) {
      _MaxQuantity = maxquantity;
    }
  }

  void setMapSpec (List<FilterSpecificAttr> mapSpec) {
     _MapSpec.addAll(mapSpec);
  }

  void setCoordinate(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
  }

  Map<String, dynamic> getMapFilter () {
    Map<String, dynamic> Filter = {
      if (_AssetType != null) "assetType": _AssetType,
      if (_Name != null) "name": _Name,
      if (_MaxQuantity != null) "maxQuantity": _MaxQuantity,
      if (_MinQuantity != null) "minQuantity": _MinQuantity,
      if (_MaxDeposit != null) "maxDeposit": _MaxDeposit,
      if (_MapSpec.isNotEmpty) "properties": _MapSpec,
      if (_MaxPrice != null) "maxPrice": _MaxPrice,
      if (_TransactionType != null) "transactionType": _TransactionType,
      if (_ValidityTime != null) "ValidityTime": _ValidityTime,
      if (_BeginTime != null) "minDate": _BeginTime,
      if (_EndTime != null) "maxDate": _EndTime,
      if (_latitude != null) "latitude": _latitude,
      if (_longitude != null) "longitude": _longitude,
      if (_distanceKilometer != null) "distance": _distanceKilometer,
    };
    return Filter;
  }
}