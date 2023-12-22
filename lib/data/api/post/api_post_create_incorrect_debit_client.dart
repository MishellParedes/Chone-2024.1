import 'dart:convert';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiCreateIncorrectDebitClient {
  static Future<dynamic> createIncorrectDebitClient(
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
        body: json.encode(Client.createDebitClient(data, user!)),
      );
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
