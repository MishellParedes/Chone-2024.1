import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiUpdateClient {
  static Future<dynamic> updateClient(Map<String, dynamic> data) async {
    final UserService userService = UserService(AmazonConstant.userPool);
    await userService.init();
    final User? user = await userService.getCurrentUser();
    final String? token = userService.session?.getIdToken().getJwtToken();
    
    try {
      final response = await http.post(
        Uri.parse(AmazonConstant.graphQLAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: json.encode(Client.updateClient(data, user!)),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['updateAfiliaciones']['id'] ??
            'Error';
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }
}
