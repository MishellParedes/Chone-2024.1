import 'dart:convert';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:http/http.dart' as http;

class ApiGenerateDebit {
  static Future<dynamic> generateDebit(
      String numCed, String cuenta, String valor) async {
    final http.Response response;
    final headers = {'Content-type': 'application/json'};
    final qParams =
        '{"clientData": {"dni": "$numCed", "account": "$cuenta", "amount":"$valor"},"process": "debito", "cooperativa": "$cooperativa"}';

    Uri uri = Uri.parse(queryClients);
    try {
      response = await http.post(uri, headers: headers, body: qParams);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)["body"]);
        return (jsonDecode(response.body)["body"]);
      }
    } catch (e) {
      return "Error";
    }
    return "Error";
  }
}
