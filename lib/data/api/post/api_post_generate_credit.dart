import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/api/global_api.dart';

class ApiGenerateCredit {
  static Future<dynamic> generateCredit(
      String numCed, String cuenta, String valor) async {
    final http.Response response;
        final headers = {'Content-type': 'application/json'};
    final qParams =
        '{"clientData": {"dni": "$numCed", "account": "$cuenta", "amount":"$valor"},"process": "devolucion", "cooperativa": "$cooperativa"}';

    Uri uri = Uri.parse(queryClients);
    try {
      response = await http.post(uri, headers: headers, body: qParams);
      if (response.statusCode == 200) {
        return (jsonDecode(response.body)["body"]);
      }
    } catch (e) {
      return "Error";
    }
    return "Error";
  }
}