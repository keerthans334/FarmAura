import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Farmaura'**
  String get appTitle;

  /// No description provided for @cropAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisor'**
  String get cropAdvisor;

  /// No description provided for @pestScanner.
  ///
  /// In en, this message translates to:
  /// **'Pest Scanner'**
  String get pestScanner;

  /// No description provided for @soilTest.
  ///
  /// In en, this message translates to:
  /// **'Soil Test'**
  String get soilTest;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @personalFinance.
  ///
  /// In en, this message translates to:
  /// **'Personal Finance'**
  String get personalFinance;

  /// No description provided for @governmentSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get governmentSchemes;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get dashboardGreetingEvening;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search crops, prices, schemes...'**
  String get searchHint;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @importantUpdates.
  ///
  /// In en, this message translates to:
  /// **'Important Updates'**
  String get importantUpdates;

  /// No description provided for @farmPerformance.
  ///
  /// In en, this message translates to:
  /// **'Farm Performance'**
  String get farmPerformance;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myFarmSummary.
  ///
  /// In en, this message translates to:
  /// **'My Farm Summary'**
  String get myFarmSummary;

  /// No description provided for @cropHistory.
  ///
  /// In en, this message translates to:
  /// **'Crop History'**
  String get cropHistory;

  /// No description provided for @savedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Saved Recommendations'**
  String get savedRecommendations;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @cropsGrown.
  ///
  /// In en, this message translates to:
  /// **'Crops Grown'**
  String get cropsGrown;

  /// No description provided for @activeFields.
  ///
  /// In en, this message translates to:
  /// **'Active Fields'**
  String get activeFields;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @landSize.
  ///
  /// In en, this message translates to:
  /// **'Land Size'**
  String get landSize;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @mainCrops.
  ///
  /// In en, this message translates to:
  /// **'Main Crops'**
  String get mainCrops;

  /// No description provided for @noCropHistory.
  ///
  /// In en, this message translates to:
  /// **'No crop history yet'**
  String get noCropHistory;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @manageFarms.
  ///
  /// In en, this message translates to:
  /// **'Manage Farms'**
  String get manageFarms;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get privacyPolicySubtitle;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsOfServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rules for using Farmaura'**
  String get termsOfServiceSubtitle;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help using the app'**
  String get helpSupportSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'About Farmaura'**
  String get aboutSubtitle;

  /// No description provided for @govJharkhand.
  ///
  /// In en, this message translates to:
  /// **'Government of Jharkhand'**
  String get govJharkhand;

  /// No description provided for @govSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart India Hackathon Problem Statement'**
  String get govSubtitle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @personalFinanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Finance'**
  String get personalFinanceTitle;

  /// No description provided for @financialOverview.
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get financialOverview;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @profitMargin.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin'**
  String get profitMargin;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @savingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get savingsGoals;

  /// No description provided for @activeLoans.
  ///
  /// In en, this message translates to:
  /// **'Active Loans'**
  String get activeLoans;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @monthlyProfitTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Profit Trend'**
  String get monthlyProfitTrend;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @quarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get quarter;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @cropWiseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Crop-wise Analysis'**
  String get cropWiseAnalysis;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @upcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Payments'**
  String get upcomingPayments;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @homeMenu.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeMenu;

  /// No description provided for @profileMenu.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileMenu;

  /// No description provided for @soilHealthCardUpload.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Card Upload'**
  String get soilHealthCardUpload;

  /// No description provided for @profitAndLoss.
  ///
  /// In en, this message translates to:
  /// **'Profit & Loss'**
  String get profitAndLoss;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login to continue'**
  String get alreadyHaveAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @enterPhoneToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneToContinue;

  /// No description provided for @enterShcNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your SHC registration number'**
  String get enterShcNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @shcId.
  ///
  /// In en, this message translates to:
  /// **'SHC ID'**
  String get shcId;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @shcRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'SHC Registration Number'**
  String get shcRegistrationNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Privacy Policy'**
  String get agreeTerms;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get enterOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {seconds}s'**
  String resendOtpIn(Object seconds);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyContinue;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @helpUsKnowYou.
  ///
  /// In en, this message translates to:
  /// **'Help us know you better'**
  String get helpUsKnowYou;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @villageName.
  ///
  /// In en, this message translates to:
  /// **'Village Name'**
  String get villageName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get emailOptional;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @farmSetup.
  ///
  /// In en, this message translates to:
  /// **'Farm Setup'**
  String get farmSetup;

  /// No description provided for @tellAboutFarm.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your farm'**
  String get tellAboutFarm;

  /// No description provided for @selectMainCrops.
  ///
  /// In en, this message translates to:
  /// **'Select Main Crops'**
  String get selectMainCrops;

  /// No description provided for @previousCrops.
  ///
  /// In en, this message translates to:
  /// **'Previous Crops'**
  String get previousCrops;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish Setup'**
  String get finishSetup;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @pestAlertNearby.
  ///
  /// In en, this message translates to:
  /// **'Pest Alert Nearby'**
  String get pestAlertNearby;

  /// No description provided for @heavyRainTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain Tomorrow'**
  String get heavyRainTomorrow;

  /// No description provided for @wheatPrice.
  ///
  /// In en, this message translates to:
  /// **'Wheat Price ₹2,150'**
  String get wheatPrice;

  /// No description provided for @cropHealth.
  ///
  /// In en, this message translates to:
  /// **'Crop Health'**
  String get cropHealth;

  /// No description provided for @soilQuality.
  ///
  /// In en, this message translates to:
  /// **'Soil Quality'**
  String get soilQuality;

  /// No description provided for @npkGood.
  ///
  /// In en, this message translates to:
  /// **'NPK Good'**
  String get npkGood;

  /// No description provided for @wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get wheat;

  /// No description provided for @soilDetails.
  ///
  /// In en, this message translates to:
  /// **'Soil Details'**
  String get soilDetails;

  /// No description provided for @soilStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Soil Status: Good'**
  String get soilStatusGood;

  /// No description provided for @basedOnRegion.
  ///
  /// In en, this message translates to:
  /// **'Based on {district} region'**
  String basedOnRegion(Object district);

  /// No description provided for @nitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N)'**
  String get nitrogen;

  /// No description provided for @phosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (P)'**
  String get phosphorus;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium (K)'**
  String get potassium;

  /// No description provided for @soilProperties.
  ///
  /// In en, this message translates to:
  /// **'Soil Properties'**
  String get soilProperties;

  /// No description provided for @phLevel.
  ///
  /// In en, this message translates to:
  /// **'pH Level'**
  String get phLevel;

  /// No description provided for @moisture.
  ///
  /// In en, this message translates to:
  /// **'Moisture'**
  String get moisture;

  /// No description provided for @organicMatter.
  ///
  /// In en, this message translates to:
  /// **'Organic Matter'**
  String get organicMatter;

  /// No description provided for @ecSalinity.
  ///
  /// In en, this message translates to:
  /// **'EC (Salinity)'**
  String get ecSalinity;

  /// No description provided for @soilInsights.
  ///
  /// In en, this message translates to:
  /// **'Soil Insights'**
  String get soilInsights;

  /// No description provided for @requestSoilTest.
  ///
  /// In en, this message translates to:
  /// **'Request Soil Test'**
  String get requestSoilTest;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @bestMandi.
  ///
  /// In en, this message translates to:
  /// **'Best Mandi To Sell – {crop}'**
  String bestMandi(Object crop);

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @alsoGoodOption.
  ///
  /// In en, this message translates to:
  /// **'Also good option'**
  String get alsoGoodOption;

  /// No description provided for @alternativeMandi.
  ///
  /// In en, this message translates to:
  /// **'Alternative mandi'**
  String get alternativeMandi;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get sellingPrice;

  /// No description provided for @transportCost.
  ///
  /// In en, this message translates to:
  /// **'Transport Cost'**
  String get transportCost;

  /// No description provided for @estimatedNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Estimated Net Profit'**
  String get estimatedNetProfit;

  /// No description provided for @allMarketPrices.
  ///
  /// In en, this message translates to:
  /// **'All Market Prices'**
  String get allMarketPrices;

  /// No description provided for @fetchingPrices.
  ///
  /// In en, this message translates to:
  /// **'Fetching latest mandi prices...'**
  String get fetchingPrices;

  /// No description provided for @couldNotLoadPrices.
  ///
  /// In en, this message translates to:
  /// **'Could not load prices'**
  String get couldNotLoadPrices;

  /// No description provided for @noPricesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No prices available right now'**
  String get noPricesAvailable;

  /// No description provided for @livePrices.
  ///
  /// In en, this message translates to:
  /// **'Live prices from nearby mandis'**
  String get livePrices;

  /// No description provided for @mspPrev.
  ///
  /// In en, this message translates to:
  /// **'MSP/Prev'**
  String get mspPrev;

  /// No description provided for @aiPowered.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered'**
  String get aiPowered;

  /// No description provided for @cropAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisory'**
  String get cropAdvisory;

  /// No description provided for @getPersonalizedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get personalized crop recommendations based on your farm\'s unique conditions'**
  String get getPersonalizedRecommendations;

  /// No description provided for @startCropAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Start Crop Advisory'**
  String get startCropAdvisory;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @farmers.
  ///
  /// In en, this message translates to:
  /// **'Farmers'**
  String get farmers;

  /// No description provided for @crops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get howItWorks;

  /// No description provided for @enterFarmDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Farm Details'**
  String get enterFarmDetails;

  /// No description provided for @provideInfo.
  ///
  /// In en, this message translates to:
  /// **'Provide information about your land size, irrigation, and location'**
  String get provideInfo;

  /// No description provided for @shareSoilData.
  ///
  /// In en, this message translates to:
  /// **'Share Soil Data'**
  String get shareSoilData;

  /// No description provided for @enterSoilInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter soil type, pH levels, and nutrient information'**
  String get enterSoilInfo;

  /// No description provided for @getAiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get AI Recommendations'**
  String get getAiRecommendations;

  /// No description provided for @receiveSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Receive top 3 crop suggestions with detailed yield and profit analysis'**
  String get receiveSuggestions;

  /// No description provided for @whyUseAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Why Use Crop Advisory?'**
  String get whyUseAdvisory;

  /// No description provided for @maximizeProfits.
  ///
  /// In en, this message translates to:
  /// **'Maximize your farm profits with data-driven decisions'**
  String get maximizeProfits;

  /// No description provided for @reduceRisk.
  ///
  /// In en, this message translates to:
  /// **'Reduce crop failure risk with suitable crop selection'**
  String get reduceRisk;

  /// No description provided for @marketDemandSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Get market-demand based crop suggestions'**
  String get marketDemandSuggestions;

  /// No description provided for @growingGuides.
  ///
  /// In en, this message translates to:
  /// **'Access detailed growing guides for each crop'**
  String get growingGuides;

  /// No description provided for @weatherForecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @sevenDayForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get sevenDayForecast;

  /// No description provided for @heavyRainWarning.
  ///
  /// In en, this message translates to:
  /// **'Heavy rainfall expected later this week. Plan your farming activities accordingly.'**
  String get heavyRainWarning;

  /// No description provided for @enterTenDigit.
  ///
  /// In en, this message translates to:
  /// **'Enter 10 digit number'**
  String get enterTenDigit;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @agriculturalWorker.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Worker'**
  String get agriculturalWorker;

  /// No description provided for @landowner.
  ///
  /// In en, this message translates to:
  /// **'Landowner'**
  String get landowner;

  /// No description provided for @tenantFarmer.
  ///
  /// In en, this message translates to:
  /// **'Tenant Farmer'**
  String get tenantFarmer;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @recommendedCrops.
  ///
  /// In en, this message translates to:
  /// **'Recommended Crops'**
  String get recommendedCrops;

  /// No description provided for @basedOnFarmConditions.
  ///
  /// In en, this message translates to:
  /// **'Based on your farm conditions'**
  String get basedOnFarmConditions;

  /// No description provided for @tryDifferentInputs.
  ///
  /// In en, this message translates to:
  /// **'Try Different Inputs'**
  String get tryDifferentInputs;

  /// No description provided for @suitabilityScore.
  ///
  /// In en, this message translates to:
  /// **'Suitability Score'**
  String get suitabilityScore;

  /// No description provided for @expectedProfit.
  ///
  /// In en, this message translates to:
  /// **'Expected Profit'**
  String get expectedProfit;

  /// No description provided for @perAcre.
  ///
  /// In en, this message translates to:
  /// **'per acre'**
  String get perAcre;

  /// No description provided for @yieldEstimate.
  ///
  /// In en, this message translates to:
  /// **'Yield Estimate'**
  String get yieldEstimate;

  /// No description provided for @whyThisCrop.
  ///
  /// In en, this message translates to:
  /// **'Why This Crop?'**
  String get whyThisCrop;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @cropDetails.
  ///
  /// In en, this message translates to:
  /// **'Crop Details'**
  String get cropDetails;

  /// No description provided for @growingRequirements.
  ///
  /// In en, this message translates to:
  /// **'Growing Requirements'**
  String get growingRequirements;

  /// No description provided for @growingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Growing Period'**
  String get growingPeriod;

  /// No description provided for @waterRequirement.
  ///
  /// In en, this message translates to:
  /// **'Water Requirement'**
  String get waterRequirement;

  /// No description provided for @temperatureRange.
  ///
  /// In en, this message translates to:
  /// **'Temperature Range'**
  String get temperatureRange;

  /// No description provided for @phRange.
  ///
  /// In en, this message translates to:
  /// **'pH Range'**
  String get phRange;

  /// No description provided for @rainfall.
  ///
  /// In en, this message translates to:
  /// **'Rainfall'**
  String get rainfall;

  /// No description provided for @growingStages.
  ///
  /// In en, this message translates to:
  /// **'Growing Stages'**
  String get growingStages;

  /// No description provided for @sowing.
  ///
  /// In en, this message translates to:
  /// **'Sowing'**
  String get sowing;

  /// No description provided for @vegetative.
  ///
  /// In en, this message translates to:
  /// **'Vegetative'**
  String get vegetative;

  /// No description provided for @flowering.
  ///
  /// In en, this message translates to:
  /// **'Flowering'**
  String get flowering;

  /// No description provided for @bollFormation.
  ///
  /// In en, this message translates to:
  /// **'Boll Formation'**
  String get bollFormation;

  /// No description provided for @harvesting.
  ///
  /// In en, this message translates to:
  /// **'Harvesting'**
  String get harvesting;

  /// No description provided for @fertilizerPlan.
  ///
  /// In en, this message translates to:
  /// **'Stage-wise Fertilizer Plan'**
  String get fertilizerPlan;

  /// No description provided for @basal.
  ///
  /// In en, this message translates to:
  /// **'Basal (At sowing)'**
  String get basal;

  /// No description provided for @firstDose.
  ///
  /// In en, this message translates to:
  /// **'First dose'**
  String get firstDose;

  /// No description provided for @secondDose.
  ///
  /// In en, this message translates to:
  /// **'Second dose'**
  String get secondDose;

  /// No description provided for @thirdDose.
  ///
  /// In en, this message translates to:
  /// **'Third dose'**
  String get thirdDose;

  /// No description provided for @irrigationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Schedule'**
  String get irrigationSchedule;

  /// No description provided for @sowingToGermination.
  ///
  /// In en, this message translates to:
  /// **'Sowing to germination'**
  String get sowingToGermination;

  /// No description provided for @vegetativeGrowth.
  ///
  /// In en, this message translates to:
  /// **'Vegetative growth'**
  String get vegetativeGrowth;

  /// No description provided for @bollDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Boll development'**
  String get bollDevelopment;

  /// No description provided for @marketInformation.
  ///
  /// In en, this message translates to:
  /// **'Market Information'**
  String get marketInformation;

  /// No description provided for @currentPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Price:'**
  String get currentPrice;

  /// No description provided for @marketTrend.
  ///
  /// In en, this message translates to:
  /// **'Market Trend:'**
  String get marketTrend;

  /// No description provided for @demand.
  ///
  /// In en, this message translates to:
  /// **'Demand:'**
  String get demand;

  /// No description provided for @majorBuyers.
  ///
  /// In en, this message translates to:
  /// **'Major Buyers:'**
  String get majorBuyers;

  /// No description provided for @viewMarketPrices.
  ///
  /// In en, this message translates to:
  /// **'View Market Prices'**
  String get viewMarketPrices;

  /// No description provided for @whyCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Why {crop}?'**
  String whyCropTitle(Object crop);

  /// No description provided for @whyCropSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s why {crop} is perfect for your farm'**
  String whyCropSubtitle(Object crop);

  /// No description provided for @highlyRecommended.
  ///
  /// In en, this message translates to:
  /// **'Highly Recommended'**
  String get highlyRecommended;

  /// No description provided for @keyFactors.
  ///
  /// In en, this message translates to:
  /// **'Key Factors'**
  String get keyFactors;

  /// No description provided for @excellentSoilMatch.
  ///
  /// In en, this message translates to:
  /// **'Excellent Soil Match'**
  String get excellentSoilMatch;

  /// No description provided for @weatherSuitability.
  ///
  /// In en, this message translates to:
  /// **'Weather Suitability'**
  String get weatherSuitability;

  /// No description provided for @rotationBenefit.
  ///
  /// In en, this message translates to:
  /// **'Rotation Benefit'**
  String get rotationBenefit;

  /// No description provided for @marketAdvantage.
  ///
  /// In en, this message translates to:
  /// **'Market Advantage'**
  String get marketAdvantage;

  /// No description provided for @growthTimeline.
  ///
  /// In en, this message translates to:
  /// **'Growth Timeline'**
  String get growthTimeline;

  /// No description provided for @germination.
  ///
  /// In en, this message translates to:
  /// **'Germination'**
  String get germination;

  /// No description provided for @harvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get harvest;

  /// No description provided for @proTip.
  ///
  /// In en, this message translates to:
  /// **'Pro Tip'**
  String get proTip;

  /// No description provided for @backToResults.
  ///
  /// In en, this message translates to:
  /// **'Back to Results'**
  String get backToResults;

  /// No description provided for @savePlan.
  ///
  /// In en, this message translates to:
  /// **'Save Plan'**
  String get savePlan;

  /// No description provided for @cropInput.
  ///
  /// In en, this message translates to:
  /// **'Crop Input'**
  String get cropInput;

  /// No description provided for @cropAdvisoryForm.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisory Form'**
  String get cropAdvisoryForm;

  /// No description provided for @fillDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill details for personalized recommendations'**
  String get fillDetails;

  /// No description provided for @sectionFarmDetails.
  ///
  /// In en, this message translates to:
  /// **'Section A - Farm Details'**
  String get sectionFarmDetails;

  /// No description provided for @irrigationType.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Type'**
  String get irrigationType;

  /// No description provided for @otherManual.
  ///
  /// In en, this message translates to:
  /// **'Other (Manual)'**
  String get otherManual;

  /// No description provided for @enterLandSize.
  ///
  /// In en, this message translates to:
  /// **'Enter land size'**
  String get enterLandSize;

  /// No description provided for @enterIrrigationType.
  ///
  /// In en, this message translates to:
  /// **'Enter irrigation type'**
  String get enterIrrigationType;

  /// No description provided for @sectionSoilInfo.
  ///
  /// In en, this message translates to:
  /// **'Section B - Soil Information'**
  String get sectionSoilInfo;

  /// No description provided for @chooseInputMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Input Method:'**
  String get chooseInputMethod;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect'**
  String get autoDetect;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @shc.
  ///
  /// In en, this message translates to:
  /// **'SHC'**
  String get shc;

  /// No description provided for @enterSoilType.
  ///
  /// In en, this message translates to:
  /// **'Enter soil type'**
  String get enterSoilType;

  /// No description provided for @soilTexture.
  ///
  /// In en, this message translates to:
  /// **'Soil Texture'**
  String get soilTexture;

  /// No description provided for @enterSoilTexture.
  ///
  /// In en, this message translates to:
  /// **'Enter soil texture'**
  String get enterSoilTexture;

  /// No description provided for @acidic.
  ///
  /// In en, this message translates to:
  /// **'Acidic (4)'**
  String get acidic;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral (7)'**
  String get neutral;

  /// No description provided for @alkaline.
  ///
  /// In en, this message translates to:
  /// **'Alkaline (10)'**
  String get alkaline;

  /// No description provided for @soilMoisture.
  ///
  /// In en, this message translates to:
  /// **'Soil Moisture (%)'**
  String get soilMoisture;

  /// No description provided for @enterMoisture.
  ///
  /// In en, this message translates to:
  /// **'Enter moisture percentage'**
  String get enterMoisture;

  /// No description provided for @uploadShc.
  ///
  /// In en, this message translates to:
  /// **'Upload Soil Health Card'**
  String get uploadShc;

  /// No description provided for @recommendedForAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Recommended for accurate results'**
  String get recommendedForAccuracy;

  /// No description provided for @shcNumber.
  ///
  /// In en, this message translates to:
  /// **'SHC Number'**
  String get shcNumber;

  /// No description provided for @enterShcNumberInput.
  ///
  /// In en, this message translates to:
  /// **'Enter SHC number'**
  String get enterShcNumberInput;

  /// No description provided for @testDate.
  ///
  /// In en, this message translates to:
  /// **'Test Date'**
  String get testDate;

  /// No description provided for @sectionCropRotation.
  ///
  /// In en, this message translates to:
  /// **'Section C - Past Crop Rotation'**
  String get sectionCropRotation;

  /// No description provided for @lastCropGrown.
  ///
  /// In en, this message translates to:
  /// **'Last Crop Grown'**
  String get lastCropGrown;

  /// No description provided for @enterLastCrop.
  ///
  /// In en, this message translates to:
  /// **'Enter last crop'**
  String get enterLastCrop;

  /// No description provided for @frequentCrop.
  ///
  /// In en, this message translates to:
  /// **'Frequent Crop'**
  String get frequentCrop;

  /// No description provided for @enterFrequentCrop.
  ///
  /// In en, this message translates to:
  /// **'Enter frequent crop'**
  String get enterFrequentCrop;

  /// No description provided for @fertilizerDetails.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Details'**
  String get fertilizerDetails;

  /// No description provided for @addFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Add Fertilizer'**
  String get addFertilizer;

  /// No description provided for @selectFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Select fertilizer'**
  String get selectFertilizer;

  /// No description provided for @enterFertilizerName.
  ///
  /// In en, this message translates to:
  /// **'Enter fertilizer name'**
  String get enterFertilizerName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @enterCustomUnit.
  ///
  /// In en, this message translates to:
  /// **'Enter custom unit'**
  String get enterCustomUnit;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @specifyFrequency.
  ///
  /// In en, this message translates to:
  /// **'Specify frequency'**
  String get specifyFrequency;

  /// No description provided for @getRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendation'**
  String get getRecommendation;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields to continue'**
  String get fillAllFields;

  /// No description provided for @pestDetection.
  ///
  /// In en, this message translates to:
  /// **'Pest Detection'**
  String get pestDetection;

  /// No description provided for @uploadPestImage.
  ///
  /// In en, this message translates to:
  /// **'Upload or capture plant image for AI analysis'**
  String get uploadPestImage;

  /// No description provided for @uploadInstructions.
  ///
  /// In en, this message translates to:
  /// **'Upload 4-5 images from different angles for accurate detection.'**
  String get uploadInstructions;

  /// No description provided for @addImages.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get addImages;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get openCamera;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @pestResult.
  ///
  /// In en, this message translates to:
  /// **'Pest Result'**
  String get pestResult;

  /// No description provided for @leafBlightDetected.
  ///
  /// In en, this message translates to:
  /// **'Leaf Blight Detected'**
  String get leafBlightDetected;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'Severity: High (85%)'**
  String get severityHigh;

  /// No description provided for @recommendedActions.
  ///
  /// In en, this message translates to:
  /// **'Recommended Actions'**
  String get recommendedActions;

  /// No description provided for @organicAlternative.
  ///
  /// In en, this message translates to:
  /// **'Organic alternative: Spray neem oil solution (5ml/liter) mixed with garlic extract.'**
  String get organicAlternative;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// No description provided for @saveReport.
  ///
  /// In en, this message translates to:
  /// **'Save Report'**
  String get saveReport;

  /// No description provided for @cotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cotton;

  /// No description provided for @soybean.
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get soybean;

  /// No description provided for @maize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get maize;

  /// No description provided for @sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get sugarcane;

  /// No description provided for @rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get rice;

  /// No description provided for @tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get tomato;

  /// No description provided for @potato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get potato;

  /// No description provided for @pestDetectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or upload an image of the affected crop to identify pests and diseases instantly.'**
  String get pestDetectionSubtitle;

  /// No description provided for @pestDetectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Ensure the affected area is clearly visible and well-lit for best results.'**
  String get pestDetectionInfo;

  /// No description provided for @chemicalControl.
  ///
  /// In en, this message translates to:
  /// **'Chemical Control'**
  String get chemicalControl;

  /// No description provided for @biologicalControl.
  ///
  /// In en, this message translates to:
  /// **'Biological Control'**
  String get biologicalControl;

  /// No description provided for @organicAlternativeTitle.
  ///
  /// In en, this message translates to:
  /// **'Organic Alternative'**
  String get organicAlternativeTitle;

  /// No description provided for @organicAlternativeDesc.
  ///
  /// In en, this message translates to:
  /// **'Mix 1 part cow urine with 10 parts water and spray on affected leaves for natural control.'**
  String get organicAlternativeDesc;

  /// No description provided for @blackCottonSoilRedSoil.
  ///
  /// In en, this message translates to:
  /// **'Black cotton soil, Red soil'**
  String get blackCottonSoilRedSoil;

  /// No description provided for @textileMillsExportMarket.
  ///
  /// In en, this message translates to:
  /// **'Textile mills, Export market'**
  String get textileMillsExportMarket;

  /// No description provided for @growingPeriodValue.
  ///
  /// In en, this message translates to:
  /// **'150-180 days'**
  String get growingPeriodValue;

  /// No description provided for @waterRequirementValue.
  ///
  /// In en, this message translates to:
  /// **'Medium (600-700mm)'**
  String get waterRequirementValue;

  /// No description provided for @temperatureRangeValue.
  ///
  /// In en, this message translates to:
  /// **'21-30°C'**
  String get temperatureRangeValue;

  /// No description provided for @phRangeValue.
  ///
  /// In en, this message translates to:
  /// **'6.0-7.5 (Slightly acidic to neutral)'**
  String get phRangeValue;

  /// No description provided for @rainfallValue.
  ///
  /// In en, this message translates to:
  /// **'600-1200mm annually'**
  String get rainfallValue;

  /// No description provided for @sowingDesc.
  ///
  /// In en, this message translates to:
  /// **'Seed treatment, Land preparation'**
  String get sowingDesc;

  /// No description provided for @vegetativeDesc.
  ///
  /// In en, this message translates to:
  /// **'Irrigation, Weeding, First fertilizer dose'**
  String get vegetativeDesc;

  /// No description provided for @floweringDesc.
  ///
  /// In en, this message translates to:
  /// **'Pest control, Second fertilizer dose'**
  String get floweringDesc;

  /// No description provided for @bollFormationDesc.
  ///
  /// In en, this message translates to:
  /// **'Regular monitoring, Adequate water supply'**
  String get bollFormationDesc;

  /// No description provided for @harvestingDesc.
  ///
  /// In en, this message translates to:
  /// **'Hand picking when bolls open'**
  String get harvestingDesc;

  /// No description provided for @dap.
  ///
  /// In en, this message translates to:
  /// **'DAP'**
  String get dap;

  /// No description provided for @urea.
  ///
  /// In en, this message translates to:
  /// **'Urea'**
  String get urea;

  /// No description provided for @npk191919.
  ///
  /// In en, this message translates to:
  /// **'NPK (19:19:19)'**
  String get npk191919;

  /// No description provided for @potash.
  ///
  /// In en, this message translates to:
  /// **'Potash'**
  String get potash;

  /// No description provided for @lightIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Light irrigation'**
  String get lightIrrigation;

  /// No description provided for @every7to10Days.
  ///
  /// In en, this message translates to:
  /// **'Every 7-10 days'**
  String get every7to10Days;

  /// No description provided for @every5to7Days.
  ///
  /// In en, this message translates to:
  /// **'Every 5-7 days'**
  String get every5to7Days;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @lessThanOneAcre.
  ///
  /// In en, this message translates to:
  /// **'< 1 Acre'**
  String get lessThanOneAcre;

  /// No description provided for @oneToTwoAcres.
  ///
  /// In en, this message translates to:
  /// **'1-2 Acres'**
  String get oneToTwoAcres;

  /// No description provided for @twoToFiveAcres.
  ///
  /// In en, this message translates to:
  /// **'2-5 Acres'**
  String get twoToFiveAcres;

  /// No description provided for @fiveToTenAcres.
  ///
  /// In en, this message translates to:
  /// **'5-10 Acres'**
  String get fiveToTenAcres;

  /// No description provided for @moreThanTenAcres.
  ///
  /// In en, this message translates to:
  /// **'> 10 Acres'**
  String get moreThanTenAcres;

  /// No description provided for @rainfed.
  ///
  /// In en, this message translates to:
  /// **'Rainfed'**
  String get rainfed;

  /// No description provided for @canal.
  ///
  /// In en, this message translates to:
  /// **'Canal'**
  String get canal;

  /// No description provided for @borewell.
  ///
  /// In en, this message translates to:
  /// **'Borewell'**
  String get borewell;

  /// No description provided for @drip.
  ///
  /// In en, this message translates to:
  /// **'Drip'**
  String get drip;

  /// No description provided for @sandy.
  ///
  /// In en, this message translates to:
  /// **'Sandy'**
  String get sandy;

  /// No description provided for @loamy.
  ///
  /// In en, this message translates to:
  /// **'Loamy'**
  String get loamy;

  /// No description provided for @clay.
  ///
  /// In en, this message translates to:
  /// **'Clay'**
  String get clay;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @fine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get fine;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @coarse.
  ///
  /// In en, this message translates to:
  /// **'Coarse'**
  String get coarse;

  /// No description provided for @organicManure.
  ///
  /// In en, this message translates to:
  /// **'Organic Manure'**
  String get organicManure;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @bags.
  ///
  /// In en, this message translates to:
  /// **'Bags'**
  String get bags;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @perStage.
  ///
  /// In en, this message translates to:
  /// **'Per Stage'**
  String get perStage;

  /// No description provided for @otherSpecify.
  ///
  /// In en, this message translates to:
  /// **'Other (Specify)'**
  String get otherSpecify;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @jharkhand.
  ///
  /// In en, this message translates to:
  /// **'Jharkhand'**
  String get jharkhand;

  /// No description provided for @noSavedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No saved recommendations'**
  String get noSavedRecommendations;

  /// No description provided for @suitability.
  ///
  /// In en, this message translates to:
  /// **'Suitability'**
  String get suitability;

  /// No description provided for @logoutClicked.
  ///
  /// In en, this message translates to:
  /// **'Logout clicked'**
  String get logoutClicked;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocation;

  /// No description provided for @locationRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please turn on your GPS location to get accurate weather and farm data.'**
  String get locationRequiredMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get locationRequired;

  /// No description provided for @yield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get yield;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
