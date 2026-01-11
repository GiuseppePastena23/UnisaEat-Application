class ApiUrl {

  static const baseURL = 'https://nonpacifical-nondefined-shanell.ngrok-free.dev/';

  static const apiVersion = 'api/v1/';

  static const login = '${apiVersion}auth/login';

  static const refresh = '${apiVersion}auth/refresh';

  static const getUser = '${apiVersion}users/getUser';

  static const getQrcode = '${apiVersion}users/generate-qr';

  static const getBalance = '${apiVersion}users/get-saldo';
  
  static const getTransactions = '${apiVersion}transazioni/get-by-userid'; 

  static String getMenuByDate(String date) {
    return '${apiVersion}menu/by-date?date=$date';
  }
}