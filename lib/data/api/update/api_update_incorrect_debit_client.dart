import 'dart:convert';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiUpdateIncorrectDebitClient {
  static Future<dynamic> updateIncorrectDebitClient(
      Map<String, dynamic> data) async {
    final UserService userService = UserService(AmazonConstant.userPool);
    await userService.init();
    final User? user = await userService.getCurrentUser();
    final token = userService.session?.getIdToken().getJwtToken();
    try {
      final response = await http.post(
        Uri.parse(AmazonConstant.graphQLAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: json.encode(Client.updateDebitClient(data, user!)),
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
