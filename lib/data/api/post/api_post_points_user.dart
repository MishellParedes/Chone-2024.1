import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/api/global_api.dart';

class ApiPointsUser {
  static Future<dynamic> pointsUser(String email) async {
    final Map<String, String> body = {
      'operationName': 'listSAPECUsuariosTables',
      'authMode': 'AMAZON_COGNITO_USER_POOLS',
      'query': '''query listSAPECUsuariosTables {
        listSAPECUsuariosTables (limit: 10000, filter: {email: {contains: "$email"}}){
          items {
            id
            agencia
            nombre
            puntos_dia
            puntos_totales
            puntos_acumulados
            email
          }
        }
      }''',
    };
    try {
      final dynamic response = await http.post(
        Uri.parse(pointsUserGraphql),
        headers: Map<String, String>.from({
          'Content-Type': 'application/json',
          'x-api-key': 'da2-eojqnvfrovctlb26ckf7xssq2a'
        }),
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body)['data']
            ['listSAPECUsuariosTables']['items'];
        if (list.isNotEmpty) {
          return list[0];
        }
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }
}
