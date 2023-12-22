import 'dart:convert';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/models/client_model.dart';

class ApiQueryPersona {
  static Future<dynamic> queryPersona(String numCed) async {
    final http.Response response;
    final headers = {'Content-type': 'application/json'};
    final qParams =
        '{"clientData": {"dni": "$numCed", "account": "", "date": "2022-01-01"},"process": "consulta", "cooperativa":"$cooperativa"}';
    Uri uri = Uri.parse(queryClients);
    try {
      response = await http.post(uri, headers: headers, body: qParams);
      if (response.statusCode == 200) {
        print("ABOPUT TO ETURN");
        return Client.fromJson(jsonDecode(response.body)["body"]);
      }
    } catch (e) {
      print("Error 1 " + e.toString());
      return "Error";
    }
    print("error 2");
    return "Error";
  }
}
