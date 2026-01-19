// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'UnisaEat';

  @override
  String get menu => 'Menu';

  @override
  String get date => 'Date';

  @override
  String get weekdays_monday => 'Monday';

  @override
  String get weekdays_tuesday => 'Tuesday';

  @override
  String get weekdays_wednesday => 'Wednesday';

  @override
  String get weekdays_thursday => 'Thursday';

  @override
  String get weekdays_friday => 'Friday';

  @override
  String get weekdays_saturday => 'Saturday';

  @override
  String get weekdays_sunday => 'Sunday';

  @override
  String get months_january => 'January';

  @override
  String get months_february => 'February';

  @override
  String get months_march => 'March';

  @override
  String get months_april => 'April';

  @override
  String get months_may => 'May';

  @override
  String get months_june => 'June';

  @override
  String get months_july => 'July';

  @override
  String get months_august => 'August';

  @override
  String get months_september => 'September';

  @override
  String get months_october => 'October';

  @override
  String get months_november => 'November';

  @override
  String get months_december => 'December';

  @override
  String get category_first => 'First Courses';

  @override
  String get category_second => 'Second Courses';

  @override
  String get category_side => 'Side Dishes';

  @override
  String get category_dessert => 'Dessert';

  @override
  String get category_drink => 'Drinks';

  @override
  String get category_other => 'Other';

  @override
  String get no_dishes_available => 'No dishes available';

  @override
  String get no_menu_found => 'No menu found for this day';

  @override
  String get error_loading => 'Error loading';

  @override
  String get retry => 'Retry';

  @override
  String greeting_morning(String name) {
    return 'Good Morning, $name!';
  }

  @override
  String get whats_on_menu => 'What\'s on the menu today?';

  @override
  String get todays_menu => 'Today\'s Menu';

  @override
  String get tap_to_see_cooking => 'Tap To See What\'s Cooking!';

  @override
  String get login_title => 'Log In';

  @override
  String get email_label => 'Email';

  @override
  String get password_label => 'Password';

  @override
  String get show_password => 'Show Password';

  @override
  String get dont_have_account => 'Don\'t Have an Account?';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get current_balance => 'Current Balance';

  @override
  String get recent_transactions => 'Recent Transactions';

  @override
  String get no_recent_transactions => 'No recent transactions';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get language_english => 'English';

  @override
  String get language_italian => 'Italian';

  @override
  String get language_spanish => 'Spanish';

  @override
  String get qr_code => 'QR Code';

  @override
  String get add_funds => 'Add Funds';

  @override
  String get transaction_type_topup => 'Top Up';

  @override
  String get transaction_type_kiosk => 'Kiosk';

  @override
  String get transaction_type_order => 'Order';

  @override
  String get orders => 'Orders';

  @override
  String get wallet => 'Wallet';

  @override
  String get theme => 'Theme';

  @override
  String get profile => 'Profile';

  @override
  String get log_out => 'Log Out';

  @override
  String get balance => 'Balance';

  @override
  String get stats => 'Stats';

  @override
  String pay_amount(String amount) {
    return 'Pay €$amount';
  }

  @override
  String get affluence_closed => 'Cafeteria Closed';

  @override
  String get affluence_opens_at => 'Opens at 12:00';

  @override
  String get affluence_good => 'Good Affluence';

  @override
  String get affluence_medium => 'Medium Affluence';

  @override
  String get affluence_high => 'High Affluence';

  @override
  String get affluence_unknown => 'Unknown';

  @override
  String get affluence_wait => 'Estimated Wait';

  @override
  String get affluence_refresh => 'Refresh';

  @override
  String get affluence_error => 'Unable to load affluence data';

  @override
  String get create_order => 'Create Order';

  @override
  String get cafeteria_status => 'Cafeteria Status';

  @override
  String get wait_time => 'WAIT TIME';
}
