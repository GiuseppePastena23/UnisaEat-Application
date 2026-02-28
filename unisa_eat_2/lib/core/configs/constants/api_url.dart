class ApiUrl {
  static const baseURL = 'https://nonpacifical-nondefined-shanell.ngrok-free.dev/';
  static const login = 'api/auth/user-login/';
  static const register = 'api/auth/register/';
  static const refresh = 'api/token/refresh/';
  static const getUser = 'api/users/me/';
  static const getQrcode = 'api/users/generate-qr/';
  static const getBalance = 'api/users/me/';
  static const getTransactions = 'api/transactions/';
  static const createPaymentIntent = 'api/payments/create-payment-intent/';
  static const getServerTime = 'api/time/';
  static const affluence = 'api/affluence/';
  static const feedback = 'api/feedback/';
  static const faqs = 'api/faqs/';

  static String getMenuByDate(String date) {
    return 'api/menus/by-date/?date=$date';
  }
}