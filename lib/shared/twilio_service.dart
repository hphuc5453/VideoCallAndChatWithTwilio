import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_constants.dart';

class TwilioFunctionsService {
  TwilioFunctionsService._();
  static final instance = TwilioFunctionsService._();
  final http.Client client = http.Client();
  final accessTokenUrl = 'https://twiliochatroomaccesstoken-6263.twil.io/accesstoken';

  static Map<String, String> getHeaders() {
    String creds = '${AppConstants.accountSID}:${AppConstants.authToken}';
    var bytes = utf8.encode(creds);
    return {'Content-Type': 'application/json', 'Authorization': 'Basic ${base64.encode(bytes)}', 'Accept': 'application/json'};
  }

  Future<dynamic> createToken(String identity) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse('$accessTokenUrl?user=$identity');
      final response = await client.get(url, headers: header);
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      return responseMap;
    } catch (error) {
      throw Exception([error.toString()]);
    }
  }
}