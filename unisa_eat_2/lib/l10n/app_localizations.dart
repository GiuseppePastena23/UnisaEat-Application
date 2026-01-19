import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'UnisaEat'**
  String get app_name;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @weekdays_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdays_monday;

  /// No description provided for @weekdays_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdays_tuesday;

  /// No description provided for @weekdays_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdays_wednesday;

  /// No description provided for @weekdays_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdays_thursday;

  /// No description provided for @weekdays_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdays_friday;

  /// No description provided for @weekdays_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdays_saturday;

  /// No description provided for @weekdays_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdays_sunday;

  /// No description provided for @months_january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get months_january;

  /// No description provided for @months_february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get months_february;

  /// No description provided for @months_march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get months_march;

  /// No description provided for @months_april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get months_april;

  /// No description provided for @months_may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get months_may;

  /// No description provided for @months_june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get months_june;

  /// No description provided for @months_july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get months_july;

  /// No description provided for @months_august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get months_august;

  /// No description provided for @months_september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get months_september;

  /// No description provided for @months_october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get months_october;

  /// No description provided for @months_november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get months_november;

  /// No description provided for @months_december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get months_december;

  /// No description provided for @category_first.
  ///
  /// In en, this message translates to:
  /// **'First Courses'**
  String get category_first;

  /// No description provided for @category_second.
  ///
  /// In en, this message translates to:
  /// **'Second Courses'**
  String get category_second;

  /// No description provided for @category_side.
  ///
  /// In en, this message translates to:
  /// **'Side Dishes'**
  String get category_side;

  /// No description provided for @category_dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get category_dessert;

  /// No description provided for @category_drink.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get category_drink;

  /// No description provided for @category_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get category_other;

  /// No description provided for @no_dishes_available.
  ///
  /// In en, this message translates to:
  /// **'No dishes available'**
  String get no_dishes_available;

  /// No description provided for @no_menu_found.
  ///
  /// In en, this message translates to:
  /// **'No menu found for this day'**
  String get no_menu_found;

  /// No description provided for @error_loading.
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get error_loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Greeting message with user name
  ///
  /// In en, this message translates to:
  /// **'Good Morning, {name}!'**
  String greeting_morning(String name);

  /// No description provided for @whats_on_menu.
  ///
  /// In en, this message translates to:
  /// **'What\'s on the menu today?'**
  String get whats_on_menu;

  /// No description provided for @todays_menu.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Menu'**
  String get todays_menu;

  /// No description provided for @tap_to_see_cooking.
  ///
  /// In en, this message translates to:
  /// **'Tap To See What\'s Cooking!'**
  String get tap_to_see_cooking;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login_title;

  /// No description provided for @email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_label;

  /// No description provided for @show_password.
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get show_password;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have an Account?'**
  String get dont_have_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @current_balance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get current_balance;

  /// No description provided for @recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recent_transactions;

  /// No description provided for @no_recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions'**
  String get no_recent_transactions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @language_italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get language_italian;

  /// No description provided for @language_spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get language_spanish;

  /// No description provided for @qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qr_code;

  /// No description provided for @add_funds.
  ///
  /// In en, this message translates to:
  /// **'Add Funds'**
  String get add_funds;

  /// No description provided for @transaction_type_topup.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get transaction_type_topup;

  /// No description provided for @transaction_type_kiosk.
  ///
  /// In en, this message translates to:
  /// **'Kiosk'**
  String get transaction_type_kiosk;

  /// No description provided for @transaction_type_order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get transaction_type_order;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// Pay button text with amount
  ///
  /// In en, this message translates to:
  /// **'Pay €{amount}'**
  String pay_amount(String amount);

  /// No description provided for @affluence_closed.
  ///
  /// In en, this message translates to:
  /// **'Cafeteria Closed'**
  String get affluence_closed;

  /// No description provided for @affluence_opens_at.
  ///
  /// In en, this message translates to:
  /// **'Opens at 12:00'**
  String get affluence_opens_at;

  /// No description provided for @affluence_good.
  ///
  /// In en, this message translates to:
  /// **'Good Affluence'**
  String get affluence_good;

  /// No description provided for @affluence_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium Affluence'**
  String get affluence_medium;

  /// No description provided for @affluence_high.
  ///
  /// In en, this message translates to:
  /// **'High Affluence'**
  String get affluence_high;

  /// No description provided for @affluence_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get affluence_unknown;

  /// No description provided for @affluence_wait.
  ///
  /// In en, this message translates to:
  /// **'Estimated Wait'**
  String get affluence_wait;

  /// No description provided for @affluence_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get affluence_refresh;

  /// No description provided for @affluence_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to load affluence data'**
  String get affluence_error;

  /// No description provided for @create_order.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get create_order;

  /// No description provided for @cafeteria_status.
  ///
  /// In en, this message translates to:
  /// **'Cafeteria Status'**
  String get cafeteria_status;

  /// No description provided for @wait_time.
  ///
  /// In en, this message translates to:
  /// **'WAIT TIME'**
  String get wait_time;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
