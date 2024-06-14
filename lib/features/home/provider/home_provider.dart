import 'package:flutter/widgets.dart';
import 'package:resilink_design/models/SpecificRent.dart';

import '../../../models/Asset.dart';
import '../../../models/News.dart';
import '../../../models/Offer.dart';

class HomeProvider extends ChangeNotifier {

  //Pour le moment Page home n'a pas de fonction pure donc mise en place de fausse news
  List<News> _listNews = [News(id: "0", country: "Egypt", institute: "Daily News Egypt", link: "https://www.dailynewsegypt.com/", img: "", platform: "web"),
    News(id: "1", country: "Egypt", institute: "Ministry of Agriculture and Land Reclamation", link: "https://moa.gov.eg/", img: "", platform: "web"),];

  //Pour le moment Page home n'a pas de fonction pure donc mise en place de fausse news
  List<Offer> _lastOfferPublish = [Offer(offerId: 0, offerer: "acazaux", assetId: 0, beginTimeSlot: "4/06/2024", endTimeSlot: "25/06/2024", validityLimit: "25/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: null),
    Offer(offerId: 1, offerer: "Benguerir", assetId: 1, beginTimeSlot: "5/06/2024", endTimeSlot: "23/06/2024", validityLimit: "23/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: null),
    Offer(offerId: 2, offerer: "Karim", assetId: 2, beginTimeSlot: "5/06/2024", endTimeSlot: "23/06/2024", validityLimit: "23/06/2024", publicationDate: "4/06/2024", offeredQuantity: 10, remainingQuantity: 10, price: 0, deposit: 0, cancellationFee: 0, rentInformation: SpecificRent(delayMargin: 0, lateRestitutionPenality: 0, deteriorationPenality: 0, nonRestitutionPenality: 0)),
  ];

  Map<int, Asset> _offerAssets = {
    0: Asset(id: 0, name: "Barley seed", description: "This late variety has good productivity with a high resistance to barley yellows. Negotiable offer, possibility of adding or removing stock.", assetType: "Crop", owner: "acazaux", transactionType: "sale/purchase", totalQuantity: 50, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "fales", image: "", specificAttributes: null),
    1: Asset(id: 1, name: "Apple", description: "Negotiable offer, possibility of adding or removing stock.", assetType: "Fruit", owner: "Benguerir", transactionType: "sale/purchase", totalQuantity: 50, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "false", image: "", specificAttributes: null),
    2: Asset(id: 2, name: "Warehouse", description: "Can store up to 50 tons of seeds or a few agricultural machines.", assetType: "Storage", owner: "Karim", transactionType: "rent", totalQuantity: null, unit: "kg", availableQuantity: 40, regulatedId: "", regulator: "false", image: "", specificAttributes: null),
  };

  List<News> get listNews => _listNews;
  List<Offer> get listLastOffer => _lastOfferPublish;
  Map<int, Asset> get listOfferAsset => _offerAssets;

}