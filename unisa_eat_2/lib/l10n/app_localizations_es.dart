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
  String get no_menu_found => 'No hay menú para este día';

  @override
  String get error_loading => 'Error al cargar';

  @override
  String get error_network => 'Error de red. Verifica tu conexión.';

  @override
  String get error_server => 'Error del servidor. Intenta de nuevo más tarde.';

  @override
  String get error_auth => 'Autenticación fallida. Inicia sesión de nuevo.';

  @override
  String get error_validation => 'Entrada no válida. Verifica e intenta de nuevo.';

  @override
  String get error_balance => 'Saldo insuficiente. Recarga tu cartera.';

  @override
  String get error_unknown => 'Ocurrió un error inesperado.';

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
  String get notificationSettings => 'Configuración de Notificaciones';

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
  String get affluence_full => 'Aforo Completo';

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

  @override
  String get faq => 'Preguntas Frecuentes';

  @override
  String get faq_category_payments => 'Pagos';

  @override
  String get faq_category_account => 'Cuenta';

  @override
  String get faq_category_orders => 'Pedidos';

  @override
  String get faq_category_general => 'General';

  @override
  String get error_loading_faq => 'Error al cargar las preguntas frecuentes';

  @override
  String get no_faqs => 'No hay preguntas frecuentes disponibles';

  @override
  String get feedback => 'Comentarios';

  @override
  String get send_feedback => 'Enviar Comentarios';

  @override
  String get feedback_category => 'Categoría';

  @override
  String get feedback_message => 'Mensaje';

  @override
  String get feedback_hint => 'Describe tus comentarios...';

  @override
  String get feedback_sent => 'Comentarios enviados con éxito';

  @override
  String get feedback_error => 'Error al enviar comentarios';

  @override
  String get feedback_suggestion => 'Sugerencia';

  @override
  String get feedback_complaint => 'Queja';

  @override
  String get feedback_bug => 'Reporte de Error';

  @override
  String get feedback_other => 'Otro';

  @override
  String get help_support => 'Ayuda y Soporte';

  @override
  String get field_required => 'Este campo es obligatorio';

  @override
  String get email_invalid => 'Ingresa un correo electrónico válido';

  @override
  String get birthdate => 'Fecha de nacimiento';

  @override
  String get password_too_short => 'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwords_not_match => 'Las contraseñas no coinciden';

  @override
  String get phone_invalid => 'Ingresa un número de teléfono válido';

  @override
  String get fiscal_code_invalid => 'Ingresa un código fiscal válido';

  @override
  String get birthdate_required => 'Ingresa tu fecha de nacimiento';

  @override
  String get already_have_account => '¿Ya tienes una cuenta?';

  @override
  String get show_at_counter => 'Mostrar en mostrador';

  @override
  String get close => 'Cerrar';

  @override
  String get phone_number => 'Número de teléfono';

  @override
  String get enable_biometric => 'Habilitar inicio de sesión biométrico';

  @override
  String get biometric_not_available => 'Autenticación biométrica no disponible';

  @override
  String get enable_notifications => 'Habilitar notificaciones';

  @override
  String get turn_on_notifications => 'Activa las notificaciones para recibir alertas';

  @override
  String get low_balance_alerts => 'Alertas de saldo bajo';

  @override
  String get balance_low_message => 'Alertar cuando el saldo esté por debajo de €5';

  @override
  String get order_status_updates => 'Actualizaciones de estado del pedido';

  @override
  String get order_status_message => 'Alertar cuando cambie el estado del pedido';

  @override
  String get transaction_alerts => 'Alertas de transacción';

  @override
  String get transaction_message => 'Alertar sobre transacciones de cartera';

  @override
  String get canteen_open => 'Comedor abierto';

  @override
  String get canteen_message => 'Alertar cuando abra el comedor';

  @override
  String get affluence_updates => 'Actualizaciones de afluencia';

  @override
  String get affluence_message => 'Alertar sobre cambios en el nivel de afluencia';

  @override
  String get bypass_time => 'Omitir restricción de tiempo';

  @override
  String get bypass_message => 'Permitir pedidos después de las 14:45';

  @override
  String get show_debug_info => 'Mostrar información de depuración';

  @override
  String get debug_info => 'Mostrar información adicional de depuración';
}
