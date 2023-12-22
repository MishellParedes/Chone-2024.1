import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSelectDiptico {
  static Future<dynamic> selectDiptico(String numCed) async {
    final String baseUrl =
        'https://same.ec/info/$numCed';
    final http.Response response;
    Uri uri = Uri.parse(baseUrl);
    try {
      response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["response"];
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }
}