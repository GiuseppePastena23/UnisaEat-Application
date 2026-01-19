// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'UnisaEat';

  @override
  String get menu => 'Menú';

  @override
  String get date => 'Fecha';

  @override
  String get weekdays_monday => 'Lunes';

  @override
  String get weekdays_tuesday => 'Martes';

  @override
  String get weekdays_wednesday => 'Miércoles';

  @override
  String get weekdays_thursday => 'Jueves';

  @override
  String get weekdays_friday => 'Viernes';

  @override
  String get weekdays_saturday => 'Sábado';

  @override
  String get weekdays_sunday => 'Domingo';

  @override
  String get months_january => 'Enero';

  @override
  String get months_february => 'Febrero';

  @override
  String get months_march => 'Marzo';

  @override
  String get months_april => 'Abril';

  @override
  String get months_may => 'Mayo';

  @override
  String get months_june => 'Junio';

  @override
  String get months_july => 'Julio';

  @override
  String get months_august => 'Agosto';

  @override
  String get months_september => 'Septiembre';

  @override
  String get months_october => 'Octubre';

  @override
  String get months_november => 'Noviembre';

  @override
  String get months_december => 'Diciembre';

  @override
  String get category_first => 'Primeros Platos';

  @override
  String get category_second => 'Segundos Platos';

  @override
  String get category_side => 'Acompañamientos';

  @override
  String get category_dessert => 'Postre';

  @override
  String get category_drink => 'Bebidas';

  @override
  String get category_other => 'Otro';

  @override
  String get no_dishes_available => 'No hay platos disponibles';

  @override
  String get no_menu_found => 'No se encontró menú para este día';

  @override
  String get error_loading => 'Error al cargar';

  @override
  String get retry => 'Reintentar';

  @override
  String greeting_morning(String name) {
    return 'Buenos días, $name!';
  }

  @override
  String get whats_on_menu => '¿Qué hay en el menú hoy?';

  @override
  String get todays_menu => 'Menú de Hoy';

  @override
  String get tap_to_see_cooking => '¡Toca Para Ver Qué Se Está Cocinando!';

  @override
  String get login_title => 'Iniciar Sesión';

  @override
  String get email_label => 'Correo Electrónico';

  @override
  String get password_label => 'Contraseña';

  @override
  String get show_password => 'Mostrar Contraseña';

  @override
  String get dont_have_account => '¿No tienes una cuenta?';

  @override
  String get sign_up => 'Registrarse';

  @override
  String get current_balance => 'Saldo Actual';

  @override
  String get recent_transactions => 'Transacciones Recientes';

  @override
  String get no_recent_transactions => 'No hay transacciones recientes';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get language_english => 'Inglés';

  @override
  String get language_italian => 'Italiano';

  @override
  String get language_spanish => 'Español';

  @override
  String get qr_code => 'Código QR';

  @override
  String get add_funds => 'Agregar Fondos';

  @override
  String get transaction_type_topup => 'Recarga';

  @override
  String get transaction_type_kiosk => 'Quiosco';

  @override
  String get transaction_type_order => 'Pedido';

  @override
  String get orders => 'Pedidos';

  @override
  String get wallet => 'Cartera';

  @override
  String get theme => 'Tema';

  @override
  String get profile => 'Perfil';

  @override
  String get log_out => 'Cerrar Sesión';

  @override
  String get balance => 'Saldo';

  @override
  String get stats => 'Estadísticas';

  @override
  String pay_amount(String amount) {
    return 'Pagar €$amount';
  }

  @override
  String get affluence_closed => 'Cafetería Cerrada';

  @override
  String get affluence_opens_at => 'Abre a las 12:00';

  @override
  String get affluence_good => 'Buena Afluencia';

  @override
  String get affluence_medium => 'Afluencia Media';

  @override
  String get affluence_high => 'Alta Afluencia';

  @override
  String get affluence_unknown => 'Desconocido';

  @override
  String get affluence_wait => 'Espera Estimada';

  @override
  String get affluence_refresh => 'Actualizar';

  @override
  String get affluence_error => 'No se pueden cargar los datos de afluencia';

  @override
  String get create_order => 'Crear Pedido';

  @override
  String get cafeteria_status => 'Estado de la Cafetería';

  @override
  String get wait_time => 'TIEMPO DE ESPERA';
}
