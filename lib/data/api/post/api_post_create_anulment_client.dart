import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiCreateAnulmentClient {
  static Future<dynamic> createAnulmentClient(Map<String, dynamic> data) async {
    final UserService userService = UserService(AmazonConstant.userPool);
    debugPrint('ApiCreateAnulmentClient');
    await userService.init();
    final String? token = userService.session?.getIdToken().getJwtToken();
    final User? user = await userService.getCurrentUser();
    try {
      final response = await http.post(
        Uri.parse(graphQLAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: json.encode(Client.createAnulmentClient(data, user!)),
      );
      debugPrint('ApiCreateAnulmentClient: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['createAfiliaciones']['id'] ??
            'Error';
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }
}
