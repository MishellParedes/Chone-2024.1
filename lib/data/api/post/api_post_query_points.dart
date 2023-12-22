import 'dart:convert';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/data/models/points_model.dart';
import 'package:http/http.dart' as http;

class ApiQueryPoints {
  static Future<dynamic> queryPoints(String plan, String transaccion) async {
    final userService = UserService(AmazonConstant.userPool);
    final token = userService.session?.getIdToken().getJwtToken();
    final Map<String, String> headers = Map<String, String>.from({
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    });
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse(graphQLAPI),
        headers: headers,
        body: json.encode(Points.queryPoints(plan, transaccion)),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['listPuntosAfiliacionesSAPOS']
                ['items'][0] ??
            'Error';
      }
    } catch (e) {
      return 'Error';
    }
    return "Error";
  }
}
