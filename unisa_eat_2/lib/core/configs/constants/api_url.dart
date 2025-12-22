// lib/core/configs/constants/api_url.dart
class ApiUrl {
  static const baseURL = 'https://nonpacifical-nondefined-shanell.ngrok-free.dev';
  static const apiVersion = 'api/v1/';

  static const login = '${apiVersion}auth/login';
  static const getUser = '${apiVersion}users/getUser';
  static const getQrcode = '${apiVersion}users/generate-qr';
  static const getBalance = '${apiVersion}users/get-saldo';
  static const getTransactions = '${apiVersion}transazioni/get-by-userid';

  // Menu endpoints - CORRECTED
  static String menuByDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final formattedDate = '$year-$month-$day';
    return '$baseURL/$apiVersion/menu/giorno?data=$formattedDate';
  }
}
