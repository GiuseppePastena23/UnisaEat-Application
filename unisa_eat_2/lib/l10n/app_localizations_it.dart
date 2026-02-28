// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_name => 'UnisaEat';

  @override
  String get menu => 'Menu';

  @override
  String get date => 'Data';

  @override
  String get weekdays_monday => 'Lunedì';

  @override
  String get weekdays_tuesday => 'Martedì';

  @override
  String get weekdays_wednesday => 'Mercoledì';

  @override
  String get weekdays_thursday => 'Giovedì';

  @override
  String get weekdays_friday => 'Venerdì';

  @override
  String get weekdays_saturday => 'Sabato';

  @override
  String get weekdays_sunday => 'Domenica';

  @override
  String get months_january => 'Gennaio';

  @override
  String get months_february => 'Febbraio';

  @override
  String get months_march => 'Marzo';

  @override
  String get months_april => 'Aprile';

  @override
  String get months_may => 'Maggio';

  @override
  String get months_june => 'Giugno';

  @override
  String get months_july => 'Luglio';

  @override
  String get months_august => 'Agosto';

  @override
  String get months_september => 'Settembre';

  @override
  String get months_october => 'Ottobre';

  @override
  String get months_november => 'Novembre';

  @override
  String get months_december => 'Dicembre';

  @override
  String get category_first => 'Primi';

  @override
  String get category_second => 'Secondi';

  @override
  String get category_side => 'Contorni';

  @override
  String get category_dessert => 'Dolce';

  @override
  String get category_drink => 'Bevande';

  @override
  String get category_other => 'Altro';

  @override
  String get no_dishes_available => 'Nessun piatto disponibile';

  @override
  String get no_menu_found => 'Nessun menu per questo giorno';

  @override
  String get error_loading => 'Errore nel caricamento';

  @override
  String get error_network => 'Errore di rete. Controlla la tua connessione.';

  @override
  String get error_server => 'Errore del server. Riprova più tardi.';

  @override
  String get error_auth => 'Autenticazione fallita. Effettua nuovamente l\'accesso.';

  @override
  String get error_validation => 'Input non valido. Controlla e riprova.';

  @override
  String get error_balance => 'Saldo insufficiente. Ricarica il tuo portafoglio.';

  @override
  String get error_unknown => 'Si è verificato un errore imprevisto.';

  @override
  String get retry => 'Riprova';

  @override
  String greeting_morning(String name) {
    return 'Buongiorno, $name!';
  }

  @override
  String get whats_on_menu => 'Cosa c\'è nel menu oggi?';

  @override
  String get todays_menu => 'Menu di Oggi';

  @override
  String get tap_to_see_cooking => 'Premi Per Vedere Cosa C\'è in Cucina!';

  @override
  String get login_title => 'Accedi';

  @override
  String get email_label => 'Email';

  @override
  String get password_label => 'Password';

  @override
  String get show_password => 'Mostra Password';

  @override
  String get dont_have_account => 'Non hai un account?';

  @override
  String get sign_up => 'Registrati';

  @override
  String get current_balance => 'Saldo Corrente';

  @override
  String get recent_transactions => 'Transazioni Recenti';

  @override
  String get no_recent_transactions => 'Nessuna transazione recente';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get language_english => 'Inglese';

  @override
  String get language_italian => 'Italiano';

  @override
  String get language_spanish => 'Spagnolo';

  @override
  String get qr_code => 'Codice QR';

  @override
  String get add_funds => 'Aggiungi Fondi';

  @override
  String get transaction_type_topup => 'Ricarica';

  @override
  String get transaction_type_kiosk => 'Chiosco';

  @override
  String get transaction_type_order => 'Ordine';

  @override
  String get orders => 'Ordini';

  @override
  String get wallet => 'Portafoglio';

  @override
  String get theme => 'Tema';

  @override
  String get profile => 'Profilo';

  @override
  String get log_out => 'Esci';

  @override
  String get notificationSettings => 'Impostazioni Notifiche';

  @override
  String get balance => 'Saldo';

  @override
  String get stats => 'Statistiche';

  @override
  String pay_amount(String amount) {
    return 'Paga €$amount';
  }

  @override
  String get affluence_closed => 'Mensa Chiusa';

  @override
  String get affluence_opens_at => 'Apre alle 12:00';

  @override
  String get affluence_good => 'Affluenza Buona';

  @override
  String get affluence_medium => 'Affluenza Media';

  @override
  String get affluence_high => 'Affluenza Alta';

  @override
  String get affluence_full => 'Capienza Massima';

  @override
  String get affluence_unknown => 'Sconosciuto';

  @override
  String get affluence_wait => 'Attesa Stimata';

  @override
  String get affluence_refresh => 'Aggiorna';

  @override
  String get affluence_error => 'Impossibile caricare i dati di affluenza';

  @override
  String get create_order => 'Crea Ordine';

  @override
  String get cafeteria_status => 'Stato Mensa';

  @override
  String get wait_time => 'TEMPO DI ATTESA';

  @override
  String get faq => 'FAQ';

  @override
  String get faq_category_payments => 'Pagamenti';

  @override
  String get faq_category_account => 'Account';

  @override
  String get faq_category_orders => 'Ordini';

  @override
  String get faq_category_general => 'Generale';

  @override
  String get error_loading_faq => 'Errore nel caricamento FAQ';

  @override
  String get no_faqs => 'Nessuna FAQ disponibile';

  @override
  String get feedback => 'Feedback';

  @override
  String get send_feedback => 'Invia Feedback';

  @override
  String get feedback_category => 'Categoria';

  @override
  String get feedback_message => 'Messaggio';

  @override
  String get feedback_hint => 'Descrivi il tuo feedback...';

  @override
  String get feedback_sent => 'Feedback inviato con successo';

  @override
  String get feedback_error => 'Errore nell\'invio del feedback';

  @override
  String get feedback_suggestion => 'Suggerimento';

  @override
  String get feedback_complaint => 'Reclamo';

  @override
  String get feedback_bug => 'Segnalazione Bug';

  @override
  String get feedback_other => 'Altro';

  @override
  String get help_support => 'Assistenza';

  @override
  String get field_required => 'Questo campo è obbligatorio';

  @override
  String get email_invalid => 'Inserisci un\'email valida';

  @override
  String get birthdate => 'Data di nascita';

  @override
  String get password_too_short => 'La password deve essere di almeno 8 caratteri';

  @override
  String get passwords_not_match => 'Le password non coincidono';

  @override
  String get phone_invalid => 'Inserisci un numero di telefono valido';

  @override
  String get fiscal_code_invalid => 'Inserisci un codice fiscale valido';

  @override
  String get birthdate_required => 'Inserisci la tua data di nascita';

  @override
  String get already_have_account => 'Hai già un account?';

  @override
  String get show_at_counter => 'Mostra al banco';

  @override
  String get close => 'Chiudi';

  @override
  String get phone_number => 'Numero di telefono';

  @override
  String get enable_biometric => 'Abilita accesso biometrico';

  @override
  String get biometric_not_available => 'Autenticazione biometrica non disponibile';

  @override
  String get enable_notifications => 'Abilita notifiche';

  @override
  String get turn_on_notifications => 'Attiva le notifiche per ricevere avvisi';

  @override
  String get low_balance_alerts => 'Avvisi saldo basso';

  @override
  String get balance_low_message => 'Avvisa quando il saldo è inferiore a €5';

  @override
  String get order_status_updates => 'Stato ordine';

  @override
  String get order_status_message => 'Avvisa quando lo stato dell\'ordine cambia';

  @override
  String get transaction_alerts => 'Avvisi transazione';

  @override
  String get transaction_message => 'Avvisa sulle transazioni del portafoglio';

  @override
  String get canteen_open => 'Mensa aperta';

  @override
  String get canteen_message => 'Avvisa quando la mensa apre';

  @override
  String get affluence_updates => 'Aggiornamenti affluenza';

  @override
  String get affluence_message => 'Avvisa sui cambiamenti dell\'affluenza';

  @override
  String get bypass_time => 'Salta limite orario';

  @override
  String get bypass_message => 'Permetti ordini dopo le 14:45';

  @override
  String get show_debug_info => 'Mostra info debug';

  @override
  String get debug_info => 'Mostra informazioni di debug aggiuntive';
}
