class AppConstants {
  static const accountSID = 'AC179e113990a61173fe5a8002b91431b8';
  static const authToken = '39b22ca4211896e2192747a323bc7e95';
  static const domainURL = 'https://conversations.twilio.com/v1';
  static late String _identity;
  static String get getIdentity => _identity;
  static String setIdentity(String identity) => _identity = identity;
}