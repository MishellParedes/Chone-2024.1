import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/models/client_model.dart' as c;
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/globals/globals.dart' as globals;

class NewApiGenerateFiles {
  static Future<dynamic> generateFiles(Map<String, dynamic> data) async {
    final http.Response response;
    final headers = {'Content-type': 'application/json'};
    final system = globals.isSapo ? 'SAPO Benefica 2023' : 'GEMA Benefica 2023';

    debugPrint("DATA inside document creation: $data");
    // convert data to json string
    final jsonData = jsonEncode(data);
    debugPrint(jsonData);

    final qParams =
        '{"client_data": $jsonData, "transaction_timestamp": "","transaction": "reg", "cooperativa":"$cooperativa", "send_email": true, "system": "$system"}';
    Uri uri = Uri.parse(documentService);
    try {
      response = await http.post(uri, headers: headers, body: qParams);
      if (response.statusCode == 200) {
        debugPrint("ABOPUT TO RETURN");
        return Client.fromJson(jsonDecode(response.body)["body"]);
      }
    } catch (e) {
      debugPrint("Error 1 $e");
      // return "Error";
    }
  }
}
