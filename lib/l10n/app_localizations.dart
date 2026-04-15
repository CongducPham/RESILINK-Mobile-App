import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Text in the country selection page
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get chooseCountry;

  /// morocco in the country selection page
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get morocco;

  /// algeria in the country selection page
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get algeria;

  /// egypt in the country selection page
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get egypt;

  /// Text in the splashscreen page
  ///
  /// In en, this message translates to:
  /// **'promote local resources sharing'**
  String get splashscreenText;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'publish'**
  String get publish;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'news'**
  String get news;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'account'**
  String get account;

  /// Title for blocked offers page
  ///
  /// In en, this message translates to:
  /// **'Blocked offers'**
  String get blockedOfferPageTitle;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'Offer purchased'**
  String get ownerOfferPurchased;

  /// Text for navigation bottom bar and header
  ///
  /// In en, this message translates to:
  /// **'Offer published'**
  String get ownerOfferPublished;

  /// Text for home page
  ///
  /// In en, this message translates to:
  /// **'Your bookmarked news sources'**
  String get homeBookmarkConnected;

  /// Text for home page
  ///
  /// In en, this message translates to:
  /// **'Last news\' sources'**
  String get homeBookmark;

  /// Text for home page
  ///
  /// In en, this message translates to:
  /// **'Suggested offer'**
  String get homeSuggestedConnected;

  /// Text for home page
  ///
  /// In en, this message translates to:
  /// **'Last Offers'**
  String get homeLastOffer;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'What are you looking for ?'**
  String get searchFirstTitle;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'There are 2 ways to search, use one of them.'**
  String get searchFirstSubText;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'Keyword'**
  String get hinderTextRequest;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get searchOr;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'Where do you search'**
  String get searchSecondTitle;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'Where is your offer'**
  String get hinderTextLocalisation;

  /// Text for search page
  ///
  /// In en, this message translates to:
  /// **'within a distance of'**
  String get searchSecondSubText;

  /// Hint text for search page
  ///
  /// In en, this message translates to:
  /// **'Where are you searching'**
  String get searchHinderTextLocalisation;

  /// Title in the publish page
  ///
  /// In en, this message translates to:
  /// **'Let\'s start....'**
  String get publishFirstTitle;

  /// subtitle in the publish page
  ///
  /// In en, this message translates to:
  /// **'publish your offer quickly in 5 easy steps'**
  String get publishFirstText;

  /// Dropdown label in the publish page
  ///
  /// In en, this message translates to:
  /// **'choose your transaction'**
  String get publishLabelChooseTransaction;

  /// Option in the chooseTransaction dropdown
  ///
  /// In en, this message translates to:
  /// **'sale/purchase'**
  String get firstTypeTransaction;

  /// Option in the chooseTransaction dropdown
  ///
  /// In en, this message translates to:
  /// **'rent'**
  String get secondTypeTransaction;

  /// Label for title input field in the publish page
  ///
  /// In en, this message translates to:
  /// **'Title of my offer'**
  String get publishLabelTitle;

  /// placeholder for title input field in the publish page
  ///
  /// In en, this message translates to:
  /// **'Type a title'**
  String get publishHinderLabelTitle;

  /// placeholder for location input field in the publish page
  ///
  /// In en, this message translates to:
  /// **'GPS coord. to enable exact search'**
  String get publishLabelLocalisation;

  /// Hint for Farm/City/Village input field in the publish page
  ///
  /// In en, this message translates to:
  /// **'e.g. El Ghazali farm in Chorfa'**
  String get publishHinterFarmCity;

  /// expandable section title for contact information in the publish page
  ///
  /// In en, this message translates to:
  /// **'contact Information'**
  String get publishContactInformation;

  /// expandable section title for additional details in the publish page
  ///
  /// In en, this message translates to:
  /// **'more details (optional)'**
  String get publishMoreDetails;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get publishLabelContactName;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Farm name'**
  String get publishLabelFarmName;

  /// Label in the publish page & account page
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get labelPhoneNumber;

  /// Label in the publish page & account page
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// Label in the publish page & account page
  ///
  /// In en, this message translates to:
  /// **'GPS coord.'**
  String get labelGps;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Duration of your offer'**
  String get publishLabelDuration;

  /// Option in the Duration dropdown in the publish page
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get firstTypeDuration;

  /// Option in the Duration dropdown in the publish page
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get secondTypeDuration;

  /// Option in the Duration dropdown in the publish page
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get thirdTypeDuration;

  /// Text button to use default location of user account in the publish page
  ///
  /// In en, this message translates to:
  /// **'Use your default location'**
  String get publishTextButtonLocalization;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Your sale or rental price'**
  String get publishLabelPrice;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Quantity of your offer'**
  String get publishLabelQuantity;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Type of your offer'**
  String get publishLabelSpecType;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Variety of your offer'**
  String get publishLabelSpecVariety;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Farm/Village/City'**
  String get publishLabelSpecLocalization;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Brand of your goods'**
  String get publishLabelSpecBrand;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Model of your goods'**
  String get publishLabelSpecModel;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Year of manufacture of your goods'**
  String get publishLabelSpecYear;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Type of usage'**
  String get publishLabelSpecUsage;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Condition of your goods'**
  String get publishLabelSpecCondition;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Where can you take the goods'**
  String get publishLabelSpecFrom;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Where do you deliver the goods'**
  String get publishLabelSpecTo;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get publishLabelDetails;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'extend duration'**
  String get publishLabelAddDuration;

  /// hinder of Details in the publish page
  ///
  /// In en, this message translates to:
  /// **'Give more details of your offer here'**
  String get publishHinderDetails;

  /// placeholder for offer type input field in the publish page
  ///
  /// In en, this message translates to:
  /// **'e.g. green apple'**
  String get publishHinderOfferType;

  /// placeholder for offer variety input field in the publish page
  ///
  /// In en, this message translates to:
  /// **'e.g. gala apple'**
  String get publishHinderOfferVariety;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Add pictures'**
  String get publishLabelImages;

  /// Text in Images container in the publish page
  ///
  /// In en, this message translates to:
  /// **'add a picture'**
  String get publishImagesText;

  /// Title in the news page
  ///
  /// In en, this message translates to:
  /// **'List of news\' sources'**
  String get newsTitle;

  /// Title in the news page
  ///
  /// In en, this message translates to:
  /// **'no news available'**
  String get newsNotFound;

  /// Title in the adding news page
  ///
  /// In en, this message translates to:
  /// **'Create your own news'**
  String get newsAddingTitle;

  /// SubTitle in the adding news page
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get newsAddingUrl;

  /// SubTitle in the adding news page
  ///
  /// In en, this message translates to:
  /// **'Institute'**
  String get newsAddingInstitute;

  /// Title in the account page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get accountProfileTitle;

  /// Label in the account page
  ///
  /// In en, this message translates to:
  /// **'Private id'**
  String get accountLabelPrivateId;

  /// Label in the account page
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get accountLabelFirstname;

  /// Label in the account page
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get accountLabelLastname;

  /// Label in the account page
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get accountLabelUsername;

  /// Label in the account page
  ///
  /// In en, this message translates to:
  /// **'Farm Location'**
  String get accountLabelLocation;

  /// Label in the account page
  ///
  /// In en, this message translates to:
  /// **'Occupation/Activity'**
  String get accountLabelJob;

  /// Title in the account page
  ///
  /// In en, this message translates to:
  /// **'Ongoing purchases'**
  String get accountPurchasesTitle;

  /// Title in the account page
  ///
  /// In en, this message translates to:
  /// **'Offers published'**
  String get accountTitlePublish;

  /// Title in the account page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get accountTitleParameters;

  /// Title in the account page
  ///
  /// In en, this message translates to:
  /// **'Evaluate the app'**
  String get accountTitleRating;

  /// First parameter in the account page
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountSubTitleLanguage;

  /// second parameter in the account page
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get accountSubTitleLocalization;

  /// Third parameter in the account page
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get accountSubTitleLogOut;

  /// Settings subtitle in the account page
  ///
  /// In en, this message translates to:
  /// **'Review the guide'**
  String get accountSubTitleOnboarding;

  /// Settings subtitle in the account page
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get accountSubTitleAboutUs;

  /// helper text in the account page
  ///
  /// In en, this message translates to:
  /// **'Your default location'**
  String get accountProfileGpsHintText;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get buttonClose;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get buttonSearch;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'publish'**
  String get buttonPublish;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'modify'**
  String get buttonModify;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'contact'**
  String get buttonContact;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'purchase'**
  String get buttonPurchase;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Let\'s start'**
  String get buttonStart;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Modify search'**
  String get buttonModifySearch;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get buttonSignIn;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get buttonSignUp;

  /// Label for button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get buttonConfirm;

  /// Text for TextButton
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMoreText;

  /// Text for TextButton
  ///
  /// In en, this message translates to:
  /// **'See all blocked offers'**
  String get allBlockedOfferText;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'Published by : '**
  String get offerDetailsPublisher;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'Publish on : '**
  String get offerDetailsPeriod;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'Ends on : '**
  String get offerDetailsPeriodEnd;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'Price : '**
  String get offerDetailsPrice;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'Quantity : '**
  String get offerDetailsQuantity;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'No price / Negotiation'**
  String get offerDetailsNoPrice;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'1 service'**
  String get offerDetailsMaterial;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'buyer : '**
  String get offerDetailsBuyer;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'Description : '**
  String get offerDetailsTitleDescription;

  /// Text in offer details page
  ///
  /// In en, this message translates to:
  /// **'no details given by seller'**
  String get offerDetailsBodyDescription;

  /// Title in result_search page
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsTitle;

  /// Title in the pop-up for expired offer
  ///
  /// In en, this message translates to:
  /// **'Expired offer'**
  String get popupTitleExpired;

  /// Text in the pop-up for expired offer
  ///
  /// In en, this message translates to:
  /// **'The validity date of your offer is expired. You can update the offer and republish it.'**
  String get popupTextExpired;

  /// Title in the pop-up for successful published offer
  ///
  /// In en, this message translates to:
  /// **'Offer published'**
  String get popupTitlePublishSuccess;

  /// Text in the pop-up for successful published offer
  ///
  /// In en, this message translates to:
  /// **'Your offer will be published within an hour'**
  String get popupTextPublishSuccess;

  /// Title in the pop-up to choose an option
  ///
  /// In en, this message translates to:
  /// **'Choose your option'**
  String get popupTitleChooseOptionImage;

  /// Title in the pop-up to confirm your action
  ///
  /// In en, this message translates to:
  /// **'Are you sure ?'**
  String get popupTitleConfirm;

  /// Title in the pop-up to select a asset's image
  ///
  /// In en, this message translates to:
  /// **'Open the default images'**
  String get popupFirstChooseOptionImage;

  /// Option 1 to select an image
  ///
  /// In en, this message translates to:
  /// **'Default images'**
  String get popupFirstOptionImageTitle;

  /// Option 2 to select an image
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get popupSecondChooseOptionImage;

  /// Option 3 to select an image
  ///
  /// In en, this message translates to:
  /// **'Open the gallery'**
  String get popupThirdChooseOptionImage;

  /// Title for language page
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePageTitle;

  /// Choice n°1 for language page
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languagePageFirstChoice;

  /// Choice n°2 for language page
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languagePageSecondChoice;

  /// Title for Server page
  ///
  /// In en, this message translates to:
  /// **'Web server'**
  String get ipAddressPageTitle;

  /// choice of ip address
  ///
  /// In en, this message translates to:
  /// **'Server 1'**
  String get ipAddressBackUp;

  /// Title for password changing page
  ///
  /// In en, this message translates to:
  /// **'Password changing'**
  String get passwordChanging;

  /// Subtitle for password changing page
  ///
  /// In en, this message translates to:
  /// **'Change your password'**
  String get passwordChangingSubTitle;

  /// explanatory text for password changing page
  ///
  /// In en, this message translates to:
  /// **'Change your password by entering your old and new passwords'**
  String get explanatoryTextPasswordChanging;

  /// Title for password changing page
  ///
  /// In en, this message translates to:
  /// **'OldPassword'**
  String get oldPassword;

  /// Title for password changing page
  ///
  /// In en, this message translates to:
  /// **'NewPassword'**
  String get newPassword;

  /// choice of ip address
  ///
  /// In en, this message translates to:
  /// **'ODEP server'**
  String get ipAddressNormal;

  /// Text to shift in the page
  ///
  /// In en, this message translates to:
  /// **'Parameters >>>'**
  String get accountShiftToParameters;

  /// Text to shift in the page
  ///
  /// In en, this message translates to:
  /// **'Offers >>>'**
  String get accountShiftToOffer;

  /// Text to shift in the page
  ///
  /// In en, this message translates to:
  /// **'Profile >>>'**
  String get accountShiftToProfile;

  /// Title in login page
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get registerLoginTitle;

  /// Label 1 in login page
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get registerLoginFirstLabel;

  /// Label 2 in login page
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerLoginSecondLabel;

  /// Text button in login page
  ///
  /// In en, this message translates to:
  /// **'No account? Sign up here >>'**
  String get registerLoginRedirection;

  /// Text for error in login page
  ///
  /// In en, this message translates to:
  /// **'Wrong username or password, try again'**
  String get registerLoginErrorConnexion;

  /// Text button in register page
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in here >>'**
  String get registerSignUpRedirection;

  /// Title in register page
  ///
  /// In en, this message translates to:
  /// **'Inscription'**
  String get registerSignUpTitle;

  /// Text error in register page
  ///
  /// In en, this message translates to:
  /// **'Your password need at least 6 characters'**
  String get registerSignUpErrorPassword;

  /// Title for pop-up if not possible to connect the user
  ///
  /// In en, this message translates to:
  /// **'Connection failure'**
  String get popupFailConnexionTitle;

  /// Text in case of a Timeout
  ///
  /// In en, this message translates to:
  /// **'Waiting period exceeded, your request cannot be processed'**
  String get popupFailConnexionTimeout;

  /// Text in case of an error in during the process in the server or no access to it
  ///
  /// In en, this message translates to:
  /// **'The connection didn\'t work properly.'**
  String get popupFailConnexionNoServer;

  /// Text for button for example
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get textOk;

  /// Text for Problems in setting up owner's offers
  ///
  /// In en, this message translates to:
  /// **'Problems retrieving owner\'s offers'**
  String get problemSetOwnerOffer;

  /// Text for Problems in setting up owner's offers
  ///
  /// In en, this message translates to:
  /// **'Problems retrieving offers purchased by the owner'**
  String get problemSetOwnerPurchased;

  /// Text for Problems in updating owner's data
  ///
  /// In en, this message translates to:
  /// **'Problems updating user\'s data'**
  String get problemSetUpdateUser;

  /// Text for Problems in deleting owner's data
  ///
  /// In en, this message translates to:
  /// **'Problems deleting user\'s offer'**
  String get problemDeleteOwnerOffer;

  /// Text for Problems in retrieving some news
  ///
  /// In en, this message translates to:
  /// **'Problems retrieving news'**
  String get problemRetrievingNews;

  /// Text for Problems in adding the news in your favorites
  ///
  /// In en, this message translates to:
  /// **'Problems in adding in your favorites the news'**
  String get problemAddingNews;

  /// Text for Problems in deleting a news from favorites
  ///
  /// In en, this message translates to:
  /// **'Problems in deleting news from your favorites'**
  String get problemDeletingNews;

  /// Text for Problems in publishing an offer
  ///
  /// In en, this message translates to:
  /// **'Problems in publishing your service'**
  String get problemPublishingOffer;

  /// Text for Problems in updating an offer
  ///
  /// In en, this message translates to:
  /// **'Problems in updating your service'**
  String get problemUpdatingOffer;

  /// Text for Problems in retrieving searched offers
  ///
  /// In en, this message translates to:
  /// **'Problems in searching the offers'**
  String get problemLoadingOffer;

  /// Text for Problems in buying an offer
  ///
  /// In en, this message translates to:
  /// **'Problems in buying the offer'**
  String get problemBuyingOffer;

  /// Text for Problems in updating a contract
  ///
  /// In en, this message translates to:
  /// **'Problems in updating your contract'**
  String get problemUpdatingContract;

  /// Text for Problems in retrieving the last offers
  ///
  /// In en, this message translates to:
  /// **'Problems in retrieving the last offers'**
  String get problemRetrievingLastOffers;

  /// Text for Problems in retrieving assetTypes
  ///
  /// In en, this message translates to:
  /// **'Problems in retrieving data from server'**
  String get problemRetrievingAssetType;

  /// Text for Problems in adding an offer in blockedOffers list
  ///
  /// In en, this message translates to:
  /// **'Problems blocking an offer'**
  String get problemBlockingOffer;

  /// Text for title updating user data
  ///
  /// In en, this message translates to:
  /// **'Updating user data...'**
  String get titlePopUpUpdateUser;

  /// Text for title pop-up deleting offer's offer
  ///
  /// In en, this message translates to:
  /// **'Deleting offer...'**
  String get titlePopUpDeletingOffer;

  /// Text for title pop-up publishing an offer
  ///
  /// In en, this message translates to:
  /// **'Publishing your offer...'**
  String get titlePopUpPublishOffer;

  /// Text for title pop-up updating an offer
  ///
  /// In en, this message translates to:
  /// **'Updating your offer...'**
  String get titlePopUpUpdatingOffer;

  /// Text for title pop-up retrieving searched offers
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get titlePopUpLoadingSearch;

  /// Text for title pop-up buying a service
  ///
  /// In en, this message translates to:
  /// **'Buying the service...'**
  String get titlePopUpBuyingOffer;

  /// Text for title pop-up updating a contract
  ///
  /// In en, this message translates to:
  /// **'Updating your contract...'**
  String get titlePopUpUpdatingContract;

  /// Text for title pop-up connection
  ///
  /// In en, this message translates to:
  /// **'Connection...'**
  String get titlePopUpLogIn;

  /// Text for title pop-up sign-up
  ///
  /// In en, this message translates to:
  /// **'Account creation...'**
  String get titlePopUpSignUp;

  /// Text for title pop-up to manage an offer
  ///
  /// In en, this message translates to:
  /// **'Modify your offer...'**
  String get titlePopUpModifyOffer;

  /// Text for title pop-up to cancel a contract
  ///
  /// In en, this message translates to:
  /// **'Cancel the purchase...'**
  String get titlePopUpCancelContract;

  /// Text for title pop-up to block an offer
  ///
  /// In en, this message translates to:
  /// **'Blocking an offer...'**
  String get titlePopUpBlockingOffer;

  /// Text for title pop-up to unblock an offer
  ///
  /// In en, this message translates to:
  /// **'Unblocking an offer'**
  String get titlePopUpUnblockingOffer;

  /// Text for body pop-up to manage an offer in case of no problems
  ///
  /// In en, this message translates to:
  /// **'Your offer has no problem'**
  String get textPopUpModifyOfferGood;

  /// Text for body pop-up to manage an offer in case of problems
  ///
  /// In en, this message translates to:
  /// **'Your offer is expired, it will not be show in the shop until it is modified'**
  String get textPopUpModifyOfferBad;

  /// Text for body pop-up to block an offer
  ///
  /// In en, this message translates to:
  /// **'Do you want to block this offer?'**
  String get textPopUpBlockOffer;

  /// Text for body pop-up to unlock an offer
  ///
  /// In en, this message translates to:
  /// **'Would you like to unblock this offer?'**
  String get textPopUpUnblockOffer;

  /// Text for page to show there is no blocked offers
  ///
  /// In en, this message translates to:
  /// **'No blocked offers'**
  String get textNoBlockedOffer;

  /// Text in case of empty list offers published
  ///
  /// In en, this message translates to:
  /// **'No offers published'**
  String get textNoOfferPublish;

  /// Text in case of empty list offers purchased
  ///
  /// In en, this message translates to:
  /// **'No offers purchased'**
  String get textNoOfferPurchase;

  /// Text in case of empty list offers publish
  ///
  /// In en, this message translates to:
  /// **'No offers available'**
  String get textNoOffer;

  /// Text in case of empty list bookmarked news
  ///
  /// In en, this message translates to:
  /// **'no bookmarked news'**
  String get textNoBookmarkedNews;

  /// Text for snackBar in case of new contract's state higher than current contract's state
  ///
  /// In en, this message translates to:
  /// **'The current status of the contract is more advanced or is the same as the selected one'**
  String get snackBarContractNotGood;

  /// Text for snackBar in case of new contract's beginTime is not passed
  ///
  /// In en, this message translates to:
  /// **'The state of the contract can only be changed 1 minute after the start of the contract'**
  String get snackBarContractTooEarly;

  /// Text for snackBar in case of none roman keyboard
  ///
  /// In en, this message translates to:
  /// **'Please switch to a roman keyboard.'**
  String get snackBarBadKeyboard;

  /// Text for snackBar in case of bad filling
  ///
  /// In en, this message translates to:
  /// **'Need to fill at least your email, username, password, lastname and firstname'**
  String get snackBarBadFilling;

  /// Text for snackBar in case of bad filling
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 6 characters long.'**
  String get snackBarPasswordBadLength;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get assetTypeFruit;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get assetTypeVegetable;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get assetTypeCrop;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Machinery'**
  String get assetTypeMachinery;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get assetTypeTransport;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get assetTypeLivestock;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Inputs'**
  String get assetTypeInputs;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get assetTypeStorage;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Labor'**
  String get assetTypeLabor;

  /// Text for assetType
  ///
  /// In en, this message translates to:
  /// **'Other services'**
  String get assetTypeOtherServices;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Change contract State'**
  String get contractChangeStateText;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Actual State'**
  String get contractActualStateText;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Change state to '**
  String get contractNewStateText;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Proceeding'**
  String get contractStateProceeding;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get contractStatePending;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get contractStateReceived;

  /// Text for contract state in offer details view
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get contractStateDelivered;

  /// User's type of activity
  ///
  /// In en, this message translates to:
  /// **'Field Of Activity'**
  String get activityDomain;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Crop Production'**
  String get activityDomainCrop;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Animal Production'**
  String get activityDomainAnimal;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Traders'**
  String get activityDomainTraders;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get activityDomainSuppliers;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get activityDomainServices;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Consulting & Assistance'**
  String get activityDomainConsulting;

  /// One of a user's areas of activity
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get activityDomainOther;

  /// User's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Field Specialization'**
  String get fieldSpecialization;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Field crops'**
  String get fieldSpecializationFieldCrops;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Vegetable crops'**
  String get fieldSpecializationVegetableCrops;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Arboriculture'**
  String get fieldSpecializationArboriculture;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Fodder'**
  String get fieldSpecializationFodder;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get fieldSpecializationCattle;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get fieldSpecializationSheep;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Goats'**
  String get fieldSpecializationGoats;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Backyard poultry'**
  String get fieldSpecializationPoultry;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Beekeepers'**
  String get fieldSpecializationBeekeepers;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Retailers'**
  String get fieldSpecializationRetailers;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Wholesalers'**
  String get fieldSpecializationWholesalers;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Agricultural equipment'**
  String get fieldSpecializationAgriculturalEquipment;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Irrigation equipment'**
  String get fieldSpecializationIrrigationEquipment;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Phytosanitary products'**
  String get fieldSpecializationPhytosanitary;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Fertilizers'**
  String get fieldSpecializationFertilizers;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get fieldSpecializationSeeds;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Equipment rental or installation'**
  String get fieldSpecializationEquipmentRental;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Labor'**
  String get fieldSpecializationLabor;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Veterinary services'**
  String get fieldSpecializationVeterinary;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get fieldSpecializationLogistics;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get fieldSpecializationPublic;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get fieldSpecializationPrivate;

  /// One of a user's specialized activity type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get fieldSpecializationOther;

  /// Subtext for onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Welcome to Resilink !'**
  String get onboardingTextPng1;

  /// Elevated Button for onboarding pages except last one
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingButtonNext;

  /// One of the titles on the “About us” page
  ///
  /// In en, this message translates to:
  /// **'About Resilink'**
  String get aboutUsFirstTitle;

  /// One of the titles on the “About us” page
  ///
  /// In en, this message translates to:
  /// **'Useful Links'**
  String get aboutUsSecondTitle;

  /// One of the paragraphs in the application description
  ///
  /// In en, this message translates to:
  /// **'Our application was created to support and facilitate access to the RESILINK platform, a solution designed to simplify the exchange of services between individuals in the agricultural sector. The main objective is to enable users to offer, request, or share services, equipment, or skills quickly, even for those who may have difficulty reading or using mobile apps.'**
  String get aboutUsDescription1;

  /// One of the paragraphs in the application description
  ///
  /// In en, this message translates to:
  /// **'RESILINK is specifically designed for the Maghreb region and targets farmers and agricultural actors. It aims to promote collaboration, solidarity and efficiency through a strong and accessible service exchange network.'**
  String get aboutUsDescription2;

  /// One of the paragraphs in the application description
  ///
  /// In en, this message translates to:
  /// **'Whether you are a producer, farmer, breeder, or involved in rural work, this application provides a communication space that encourages mutual support and helps strengthen the agricultural community as a whole.'**
  String get aboutUsDescription3;

  /// One of the two link text
  ///
  /// In en, this message translates to:
  /// **'RESILINK Official Website'**
  String get aboutUsFirstLink;

  /// One of the two link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutUsSecondLink;

  /// Label in the publish page
  ///
  /// In en, this message translates to:
  /// **'Share with all servers'**
  String get publishLabelAcceptSharing;

  /// Label in a button
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get buttonTitleChangePassword;

  /// Title for servers page
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get serverPageTitle;

  /// Subtitle for servers page
  ///
  /// In en, this message translates to:
  /// **'All Servers'**
  String get serverPageSubTitle1;

  /// Subtitle for servers page
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get serverPageSubTitle2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
