import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/api/global_api.dart';

class ApiUpdatePointsUser {
  static Future updatePointsUser(String userId, int points) async {
    final Map<String, String> body = {
      'operationName': 'updateSAPECUsuariosTable',
      'authMode': 'AMAZON_COGNITO_USER_POOLS',
      'query': '''mutation updateSAPECUsuariosTable {
      updateSAPECUsuariosTable (input:{
        id:"$userId",
        puntos_acumulados:$points}){
          id
          puntos_acumulados
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
        return jsonDecode(response.body)['data']['updateSAPECUsuariosTable']
            ['id'];
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }
}
